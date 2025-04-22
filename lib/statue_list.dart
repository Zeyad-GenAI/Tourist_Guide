import 'package:flutter/material.dart';

class StatueList extends StatelessWidget {
  final bool isFavorites;

  const StatueList({super.key, this.isFavorites = false});

  @override
  Widget build(BuildContext context) {
    final statues = isFavorites
        ? [
      {
        'name': 'Adhenaton',
        'url': 'www.a-blog.ftc-1353-38',
        'description': 'RCI of ancient Egypt of the 18th dynasty'
      },
      {
        'name': 'Hatshepsut',
        'url': 'www.the divine Egypt tribe',
        'description': 'Phasarch Thurianan II and the fifth Phasarch of the E...'
      },
    ]
        : [
      {
        'name': 'Adhenaton',
        'url': 'www.a-blog.ftc-1353-38',
        'description': 'RCI of ancient Egypt of the 18th dynasty'
      },
      {
        'name': 'Nefertiti',
        'url': 'www.the essence of Egypt',
        'description': 'and mile of King Abbasaston (formerly Amendostop)'
      },
      {
        'name': 'Ramesses II',
        'url': 'www.sha-tarifed.kong-old-like',
        'description': '19th dynasty (TAPATUM BEA)'
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: statues.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            statues[index]['name']!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(statues[index]['url']!),
              Text(statues[index]['description']!),
            ],
          ),
        );
      },
    );
  }
}