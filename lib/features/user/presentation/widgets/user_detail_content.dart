import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

/// Widget displaying detailed user information
class UserDetailContent extends StatelessWidget {
  final User user;

  const UserDetailContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildContactInfo(context),
          const SizedBox(height: 24),
          _buildAddressInfo(context),
          const SizedBox(height: 24),
          _buildCompanyInfo(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '@${user.username}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.email, 'Email', user.email),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.phone, 'Phone', user.phone),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.web, 'Website', user.website),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.location_on, 'Street', user.address.street),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.apartment, 'Suite', user.address.suite),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_city, 'City', user.address.city),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.local_post_office,
              'Zipcode',
              user.address.zipcode,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.map,
              'Coordinates',
              '${user.address.geo.lat}, ${user.address.geo.lng}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.business, 'Name', user.company.name),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.tag, 'Catch Phrase', user.company.catchPhrase),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.info, 'BS', user.company.bs),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
