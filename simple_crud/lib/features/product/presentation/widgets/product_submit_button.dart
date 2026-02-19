import 'package:flutter/material.dart';

class ProductSubmitButton extends StatelessWidget {
  final bool isLoading;
  final bool isEditing;
  final VoidCallback? onPressed;

  const ProductSubmitButton({
    super.key,
    required this.isLoading,
    required this.isEditing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                isEditing ? 'Update Product' : 'Save Product',
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
