import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Page'),
      ),
      body: ListView(
        children: [
          // American Airlines News
          NewsItem(
            title: 'Unexpected storms divert 100 American Airlines flights',
            subtitle: 'Hundreds of cancellations sparked',
            author: 'Marnie Hunter',
            date: 'Recent News',
            onTap: () {
              // Navigate to detailed news page
              // Implement your navigation logic here
            },
            backgroundColor: Colors.blue.shade100, // Background color for the card
            icon: Icons.account_circle, // Icon for the account
          ),

          // Teens have abandoned Facebook
          NewsItem(
            title: 'Teens have abandoned Facebook',
            subtitle: 'Pew study says Gen Z internet use is on the rise',
            author: 'Recent News',
            date: '',
            onTap: () {
              // Navigate to detailed news page
              // Implement your navigation logic here
            },
            backgroundColor: Colors.green.shade100, // Background color for the card
            icon: Icons.account_circle, // Icon for the account
          ),

          // Tubi expands its free streaming service
          NewsItem(
            title: 'Fox-owned Tubi expands its free streaming service',
            subtitle: 'Now available in five Latin American countries',
            author: 'Recent News',
            date: '',
            onTap: () {
              // Navigate to detailed news page
              // Implement your navigation logic here
            },
            backgroundColor: Colors.orange.shade100, // Background color for the card
            icon: Icons.account_circle, // Icon for the account
          ),
        ],
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String author;
  final String date;
  final VoidCallback onTap;
  final Color backgroundColor; // Background color for the card
  final IconData icon; // Icon for the account

  NewsItem({
    required this.title,
    required this.subtitle,
    required this.author,
    required this.date,
    required this.onTap,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon), // Display icon for the account
                  SizedBox(width: 8),
                  Text(
                    'Author: $author',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'Date: $date',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
