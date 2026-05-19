import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileViewDetailsScreen extends StatelessWidget {
  const ProfileViewDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile View', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Theme.of(context).primaryColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.secondary, size: 28),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (value) {},
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'hide', child: Text('Hide Profile')),
              const PopupMenuItem<String>(value: 'block', child: Text('Block Profile')),
              const PopupMenuItem<String>(value: 'report', child: Text('Report Profile')),
            ],
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Top Image Card
              Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: AssetImage('assets/blurredProfile1.png'), // Blurred profile
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.6)],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.favorite, color: Colors.white, size: 28),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.photo_library_outlined, color: Colors.white, size: 16),
                                    SizedBox(width: 4),
                                    Text('5', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.lock_outline, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Photos will be revealed after mutual interest',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite, size: 18, color: Colors.white),
                              label: const Text('Send Interest', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Tabs
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF2F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  tabs: const [
                    Tab(text: 'Basic Info'),
                    Tab(text: 'About Me'),
                    Tab(text: 'Preferences'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Tab Content Area
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF2F3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  height: 600, // Fixed height or you can use listview inside
                  child: TabBarView(
                    children: [
                      _buildBasicInfoTab(),
                      _buildAboutMeTab(),
                      _buildPreferencesTab(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Info Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Full name, photos and contact details are only shared at the appropriate stage of the connection process.',
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return ListView(
      children: [
        _buildReadOnlyField('Name', 'mm31'),
        _buildReadOnlyField('Date of Birth', '14 / 08 / 1998'),
        _buildReadOnlyField('City', 'London', icon: Icons.location_on_outlined),
        _buildReadOnlyField('Country', 'United Kingdom'),
        _buildReadOnlyField('Sect', 'Shia'),
        _buildReadOnlyField('Marital Status', 'Single'),
        _buildReadOnlyField('Ethnicity', 'Arab'),
        _buildReadOnlyField('Nationality/ Citizenship', 'British citizenship'),
        _buildReadOnlyField('Do you have children?', 'No'),
        _buildReadOnlyField('How many children do you have?', 'None'),
        _buildReadOnlyField('Height', '5\'6 ft'),
        _buildReadOnlyField('Weight', '58 kg'),
        _buildReadOnlyField('Prayer 5x a day?', 'Mostly'),
        _buildReadOnlyField('Are you open to relocating?', 'Mostly'),
        _buildReadOnlyField('How do you dress?', 'Modestly'),
      ],
    );
  }

  Widget _buildAboutMeTab() {
    return ListView(
      children: [
        _buildReadOnlyField('Idea of marriage', 'Discover the endless possibilities with our innovative platform designed to simplify your daily tasks and boost productivity.', maxLines: 3),
        _buildReadOnlyField('Describe your relationship with Islam?', 'Life is a continuous journey filled with moments of spiritual growth and challenges, through various experiences.', maxLines: 3),
        _buildReadOnlyField('How do you envision your role as a spouse?', 'Sure! Here\'s a detailed answer for the heading you provided. Please share the heading so I can tailor the content accordingly.', maxLines: 3),
        _buildReadOnlyField('Tell me a bit about yourself?', 'Lorem ipsum dolor sit amet consectetur. Condimentum massa nec tortor turpis. Proin adipiscing duis nam accumsan mattis ante.', maxLines: 3),
        _buildReadOnlyField('How do you envision your spouse to be?', 'Lorem ipsum dolor sit amet consectetur. Adipiscing donec sem tortor magna. Mi dui in enim eu consequat libero convallis proin.', maxLines: 3),
        _buildReadOnlyField('How do you envision your marriage to be?', 'Lorem ipsum dolor sit amet consectetur. Aliquam vel adipiscing mattis lacus lacus. Pretium proin porttitor in cursus luctus eu sit.', maxLines: 3),
        _buildReadOnlyField('Preference on spouse\'s religious status?', 'Lorem ipsum dolor sit amet consectetur. Neque dui amet volutpat vehicula urna a enim.', maxLines: 3),
      ],
    );
  }

  Widget _buildPreferencesTab() {
    return ListView(
      children: [
        _buildReadOnlyField('Preferred Age Range', '22-35'),
        _buildReadOnlyField('Preferred Marital Status', 'Never been married'),
        const Text('Preferred Ethnicity', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildChip('Pakistan'),
            const SizedBox(width: 8),
            _buildChip('Arab'),
            const SizedBox(width: 8),
            _buildChip('Turkish'),
          ],
        ),
        const SizedBox(height: 16),
        _buildReadOnlyField('Preference to country of residence', 'United Kingdom'),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value, {IconData? icon, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                    maxLines: maxLines,
                    overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
    );
  }
}

