import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Falling Chess Choice',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final List<String> _pieces = [
    'king',
    'queen',
    'rook',
    'bishop',
    'knight',
    'pawn',
  ];
  String _currentFallingPieceName = '';
  double _fallingPiecePosition = 0;
  final double _fallSpeed = 2.0;
  double _screenHeight = 0;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _generateFallingPiece(); // Generate an initial falling piece
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenHeight = MediaQuery.of(context).size.height;
      _startFalling();
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _generateFallingPiece() {
    final random = Random();
    setState(() {
      _currentFallingPieceName = _pieces[random.nextInt(_pieces.length)];
      _fallingPiecePosition = 0;
    });
    _startFalling();
  }

  void _handlePieceSelection(String selectedPiece) {
    _generateFallingPiece();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You selected: $selectedPiece'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _startFalling() {
    _animationController?.dispose();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {
        _fallingPiecePosition += _fallSpeed;
        if (_fallingPiecePosition > _screenHeight) {
          _generateFallingPiece();
        }
      });
    });
    _animationController?.forward();
  }

  String _getImagePath(String pieceName) {
    return pieceName.isNotEmpty
        ? 'assets/${pieceName.toLowerCase()}.png'
        : ''; // Add a check for empty string
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Falling Chess Choice')),
      body: Stack(
        children: [
          if (_currentFallingPieceName
              .isNotEmpty) // Conditionally render the image
            Positioned(
              top: _fallingPiecePosition,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: Image.asset(
                _getImagePath(_currentFallingPieceName),
                height: 60,
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                alignment: WrapAlignment.center,
                children:
                    _pieces
                        .map(
                          (pieceName) => ElevatedButton(
                            onPressed: () => _handlePieceSelection(pieceName),
                            child: Text(pieceName),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
