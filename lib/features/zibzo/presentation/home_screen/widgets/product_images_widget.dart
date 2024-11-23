import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageRow extends StatelessWidget {
  final List<String> imageUrls;

  const CustomImageRow({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const SizedBox();
    } else if (imageUrls.length == 1) {
      return _SingleImage(url: imageUrls[0]);
    } else if (imageUrls.length == 2) {
      return _TwoImages(urls: imageUrls);
    } else {
      return _MultipleImages(urls: imageUrls);
    }
  }
}

class _SingleImage extends StatelessWidget {
  final String url;

  const _SingleImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ImageContainer(url: url, height: 216);
  }
}

class _TwoImages extends StatelessWidget {
  final List<String> urls;

  const _TwoImages({Key? key, required this.urls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: urls.map((url) {
        return Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: _ImageContainer(url: url, height: 216),
        ));
      }).toList(),
    );
  }
}

class _MultipleImages extends StatelessWidget {
  final List<String> urls;

  const _MultipleImages({Key? key, required this.urls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ImageContainer(url: urls[0], height: 216),
        ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: _ImageContainer(url: urls[1], height: 105),
              ),
              const SizedBox(height: 5),
              _buildOverlayImage(urls),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayImage(List<String> urls) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _ImageContainer(url: urls[2], height: 105),
          if (urls.length > 3) _buildCountOverlay(urls.length - 2),
        ],
      ),
    );
  }

  Widget _buildCountOverlay(int count) {
    return Container(
      width: double.infinity,
      height: 105,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(
          Colors.black.red, // Red component of Colors.black
          Colors.black.green, // Green component of Colors.black
          Colors.black.blue, // Blue component of Colors.black
          0.5, // Opacity (0.0 - 1.0)
        ),
      ),
      alignment: Alignment.center,
      child: Center(
        child: Text(
          '+$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ImageContainer extends StatelessWidget {
  final String url;
  final double height;

  const _ImageContainer({Key? key, required this.url, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: CachedNetworkImage(
        imageUrl: "http://localhost:4000/$url",
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
