import 'package:flutter/material.dart';

/// Parses basic HTML snippets returned by CMS/admin endpoints (such as
/// Terms and Conditions or Privacy Policy) into styled Flutter [InlineSpan]s.
class HtmlTextFormatter {
  HtmlTextFormatter._();

  static const Map<String, String> _namedEntities = {
    'nbsp': ' ',
    'amp': '&',
    'lt': '<',
    'gt': '>',
    'quot': '"',
    'apos': "'",
    '#39': "'",
    'rsquo': '\u2019',
    'lsquo': '\u2018',
    'rdquo': '\u201D',
    'ldquo': '\u201C',
    'ndash': '\u2013',
    'mdash': '\u2014',
    'bull': '\u2022',
    'hellip': '\u2026',
  };

  /// Decodes common named and numeric HTML entities.
  static String decodeEntities(String input) {
    if (!input.contains('&')) return input;
    return input.replaceAllMapped(RegExp(r'&(#x?[0-9a-fA-F]+|[a-zA-Z]+);'), (m) {
      final token = m.group(1)!;
      if (token.startsWith('#x') || token.startsWith('#X')) {
        final code = int.tryParse(token.substring(2), radix: 16);
        return code != null ? String.fromCharCode(code) : m.group(0)!;
      }
      if (token.startsWith('#')) {
        final code = int.tryParse(token.substring(1));
        return code != null ? String.fromCharCode(code) : m.group(0)!;
      }
      return _namedEntities[token.toLowerCase()] ?? m.group(0)!;
    });
  }

  /// Normalizes block-level HTML tags (`<p>`, `<br>`, `<li>`, `<h1..h6>`) while
  /// keeping inline styling tags (`<strong>`, `<b>`, `<em>`, `<i>`, `<u>`) intact.
  static String _normalizeBlocks(String rawHtml) {
    var normalized = rawHtml.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // Drop script/style content if ever present.
    normalized = normalized.replaceAll(
      RegExp(r'<(script|style)[^>]*>[\s\S]*?</\1>', caseSensitive: false),
      '',
    );

    // Strip leading <br> immediately inside block tags (e.g. <p><strong><br>...).
    normalized = normalized.replaceAllMapped(
      RegExp(
        r'(<(?:p|div|li|h[1-6])[^>]*>(?:\s*<(?:strong|b|em|i|u)[^>]*>)*)\s*(?:<br\s*/?>\s*)+',
        caseSensitive: false,
      ),
      (m) => m.group(1)!,
    );

    // Headings -> bold block with clear spacing.
    normalized = normalized.replaceAllMapped(
      RegExp(r'<h[1-6][^>]*>([\s\S]*?)</h[1-6]>', caseSensitive: false),
      (m) => '\n\n<strong>${m.group(1)!.trim()}</strong>\n\n',
    );

    // List items -> bullet lines.
    normalized = normalized.replaceAll(
      RegExp(r'<li[^>]*>', caseSensitive: false),
      '\n• ',
    );
    normalized = normalized.replaceAll(
      RegExp(r'</li>', caseSensitive: false),
      '',
    );

    // Line breaks and block boundaries.
    normalized = normalized.replaceAll(
      RegExp(r'<br\s*/?>', caseSensitive: false),
      '\n',
    );
    normalized = normalized.replaceAll(
      RegExp(r'</(?:p|div|ul|ol|blockquote)>', caseSensitive: false),
      '\n\n',
    );
    normalized = normalized.replaceAll(
      RegExp(r'<(?:p|div|ul|ol|blockquote)[^>]*>', caseSensitive: false),
      '',
    );

    return normalized;
  }

  /// Converts HTML into clean formatted [InlineSpan]s for [Text.rich].
  static List<InlineSpan> toSpans(
    String rawHtml, {
    TextStyle? baseStyle,
  }) {
    if (rawHtml.isEmpty) return const [TextSpan(text: '')];

    final prepared = _normalizeBlocks(rawHtml);
    final spans = <InlineSpan>[];
    final tagRegex = RegExp(r'<[^>]+>');

    int boldDepth = 0;
    int italicDepth = 0;
    int underlineDepth = 0;
    int trailingNewlines = 0;
    int cursor = 0;

    void emitText(String rawSegment) {
      if (rawSegment.isEmpty) return;
      var text = decodeEntities(rawSegment);
      // Clean spaces around newlines and collapse 3+ consecutive newlines.
      text = text.replaceAll(RegExp(r'[ \t]+\n'), '\n');
      text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
      if (spans.isEmpty) {
        text = text.replaceFirst(RegExp(r'^\n+'), '');
      } else if (trailingNewlines > 0) {
        final leadingMatch = RegExp(r'^\n+').firstMatch(text);
        if (leadingMatch != null) {
          final allowed = (2 - trailingNewlines).clamp(0, 2);
          final leadingCount = leadingMatch.group(0)!.length;
          if (leadingCount > allowed) {
            text = ('\n' * allowed) + text.substring(leadingCount);
          }
        }
      }
      if (text.isEmpty) return;

      final trailingMatch = RegExp(r'\n+$').firstMatch(text);
      trailingNewlines =
          trailingMatch != null ? trailingMatch.group(0)!.length : 0;

      final style = (baseStyle ?? const TextStyle()).copyWith(
        fontWeight: boldDepth > 0 ? FontWeight.w700 : baseStyle?.fontWeight,
        fontStyle: italicDepth > 0 ? FontStyle.italic : baseStyle?.fontStyle,
        decoration: underlineDepth > 0
            ? TextDecoration.underline
            : baseStyle?.decoration,
      );
      spans.add(TextSpan(text: text, style: style));
    }

    for (final match in tagRegex.allMatches(prepared)) {
      if (match.start > cursor) {
        emitText(prepared.substring(cursor, match.start));
      }
      final rawTag = match.group(0)!;
      final tagNameMatch = RegExp(r'^<\s*(/?)\s*([a-zA-Z0-9]+)').firstMatch(rawTag);
      if (tagNameMatch != null) {
        final isClosing = tagNameMatch.group(1) == '/';
        final tag = tagNameMatch.group(2)!.toLowerCase();
        if (tag == 'strong' || tag == 'b') {
          boldDepth = isClosing ? (boldDepth > 0 ? boldDepth - 1 : 0) : boldDepth + 1;
        } else if (tag == 'em' || tag == 'i') {
          italicDepth =
              isClosing ? (italicDepth > 0 ? italicDepth - 1 : 0) : italicDepth + 1;
        } else if (tag == 'u') {
          underlineDepth = isClosing
              ? (underlineDepth > 0 ? underlineDepth - 1 : 0)
              : underlineDepth + 1;
        }
      }
      cursor = match.end;
    }

    if (cursor < prepared.length) {
      emitText(prepared.substring(cursor));
    }

    // Trim trailing whitespace/newlines at end of document.
    while (spans.isNotEmpty) {
      final last = spans.last;
      if (last is TextSpan && last.text != null) {
        final trimmed = last.text!.replaceFirst(RegExp(r'\s+$'), '');
        if (trimmed.isEmpty) {
          spans.removeLast();
          continue;
        }
        if (trimmed != last.text) {
          spans[spans.length - 1] = TextSpan(text: trimmed, style: last.style);
        }
      }
      break;
    }

    if (spans.isEmpty) {
      return [TextSpan(text: '', style: baseStyle)];
    }
    return spans;
  }

  /// Strips HTML tags cleanly into readable plain text.
  static String toPlainText(String rawHtml) {
    final buffer = StringBuffer();
    for (final span in toSpans(rawHtml)) {
      if (span is TextSpan && span.text != null) {
        buffer.write(span.text);
      }
    }
    return buffer.toString();
  }
}
