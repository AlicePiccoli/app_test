import 'package:instagrume/import.dart';

class ActionButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const ActionButton({super.key, required this.onTap, required this.text});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  Color _buttonColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Durée de l'animation
        padding: const EdgeInsets.all(25),
        // margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: _buttonColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
            child: Text(
          widget.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          ),
        )),
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _buttonColor = Colors.grey; // Change la couleur lorsque le clic commence
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _buttonColor =
          Colors.grey; // Change la couleur lorsque le clic est relâché
    });
    widget.onTap(); // Appeler la fonction onTap fournie
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _buttonColor =
            Colors.black; // Revenir à la couleur d'origine avec un petit délai
      });
    });
  }

  void _handleTapCancel() {
    setState(() {
      _buttonColor =
          Colors.black; // Revenir à la couleur d'origine si le clic est annulé
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _buttonColor =
            Colors.black; // Revenir à la couleur d'origine avec un petit délai
      });
    });
  }
}
