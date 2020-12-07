import 'package:challenges/constants.dart';
import 'package:challenges/pages/bubbles/bubbles.dart';
import 'package:challenges/pages/color_interpolation/color_interpolation.dart';
import 'package:challenges/pages/fractals/fractals.dart';
import 'package:challenges/pages/invaders/invaders.dart';
import 'package:challenges/pages/lorenz_attractor/lorenz_attractor.dart';
import 'package:challenges/pages/maze_generator/maze_generator.dart';
import 'package:challenges/pages/mitosis/mitosis.dart';
import 'package:challenges/pages/purple_rain/purple_rain.dart';
import 'package:challenges/pages/reaction_diffusion/reaction_diffusion.dart';
import 'package:challenges/pages/rotating_cube/rotating_cube.dart';
import 'package:challenges/pages/snake_game/snake_game.dart';
import 'package:challenges/pages/solar_system/solar_system.dart';
import 'package:challenges/pages/sphere/sphere.dart';
import 'package:challenges/pages/spring_simulation/spring_simulation.dart';
import 'package:challenges/pages/starfield/starfield.dart';
import 'package:challenges/pages/super_ellipse/super_ellipse.dart';
import 'package:challenges/pages/terrain_generation/terrain_generation.dart';
import 'package:challenges/pages/walkers/walkers.dart';
import 'package:flutter/material.dart';

// Look at the stuff here https://github.com/flutter/flutter/blob/master/examples/layers/raw/spinning_square.dart
// Pretty cool
void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Home(),
      routes: {
        '/reaction_diffusion': (_) => ReactionDiffusion(),
        '/spring_simulation': (_) => SpringSimulation(),
        '/super_ellipse': (_) => SuperEllipse(),
        '/lorenz_attractor': (_) => LorenzAttractor(),
        '/rotating_cube': (_) => RotatingCube(),
        '/terrain_generation': (_) => TerrainGeneration(),
        '/maze_generator': (_) => MazeGenerator(),
        '/solar_system': (_) => SolarSystem(),
        '/walkers': (_) => Walkers(),
        '/fractals': (_) => Fractals(),
        '/bubbles': (_) => Bubbles(),
        '/starfield': (_) => Starfield(),
        '/snake': (_) => SnakeGame(),
        '/purple_rain': (_) => PurpleRain(),
        '/invaders': (_) => Invaders(),
        '/color_interpolation': (_) => ColorInterpolation(),
        '/mitosis': (_) => Mitosis(),
        '/sphere': (_) => Sphere(),
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView(
          padding: const EdgeInsets.all(kPa),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          children: <Widget>[
            PageButton(
              title: 'Sphere',
              to: '/sphere',
              description: 'I\'m drawing a sphere!',
            ),
            PageButton(
              title: 'Reaction Diffusion',
              to: '/reaction_diffusion',
              description: 'Drawing some stuff to the canvas',
            ),
            PageButton(
              title: 'Spring Simulation',
              to: '/spring_simulation',
              description:
                  'A simple spring simulation using Flutter libraries ',
            ),
            PageButton(
              title: 'A simple super ellipse',
              to: '/super_ellipse',
              description: 'Watch as the value of n animates',
            ),
            PageButton(
              title: 'A Lorenz Attractor',
              to: '/lorenz_attractor',
              description: 'A Differential Lorenz system.',
            ),
            PageButton(
              title: 'A rotating cube!',
              to: '/rotating_cube',
              description: 'My first experience with a perspective matrix',
            ),
            PageButton(
              title: 'Terrain Generation',
              to: '/terrain_generation',
              description: 'Oh no! The matrices!',
            ),
            PageButton(
              title: 'Maze Generator',
              to: '/maze_generator',
              description: 'A generator for mazes',
            ),
            PageButton(
              title: 'Solar System',
              to: '/solar_system',
              description: 'A 2D solar system',
            ),
            PageButton(
              title: 'Walkers',
              to: '/walkers',
              description:
                  'Animated Walkers using random, perlin and symplex noise',
            ),
            PageButton(
              title: 'Fractals',
              to: '/fractals',
              description: 'Simple and L-System Recursive fractals',
            ),
            PageButton(
              title: 'Starfield',
              to: '/starfield',
              description: 'Plain Jane implemention of a starfield',
            ),
            PageButton(
              title: 'Bubbles',
              to: '/bubbles',
              description:
                  'An extension of starfield for drawing popping bubbles',
            ),
            PageButton(
              title: 'Snake',
              to: '/snake',
              description: 'Snake game!',
            ),
            PageButton(
              title: 'Purple Rain',
              to: '/purple_rain',
              description: 'Purple rain with simple physics',
            ),
            PageButton(
              title: 'Invaders',
              to: '/invaders',
              description: 'Fighting off some invaders',
            ),
            // PageButton(
            //   title: 'Color Interpolation',
            //   to: '/color_interpolation',
            //   description: 'Interpolate between four colors',
            // ),
            PageButton(
              title: 'Mitosis',
              to: '/mitosis',
              description: 'Splitting some cells today!',
            ),
          ],
        ),
      ),
    );
  }
}

class PageButton extends StatelessWidget {
  const PageButton({
    this.title,
    this.to,
    this.description,
  })  : assert(title != null),
        assert(to != null);

  final String to;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, to),
        child: Padding(
          padding: const EdgeInsets.all(kPa),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.headline6.copyWith(),
              ),
              const SizedBox(height: kGapSmall),
              Expanded(
                child: Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 16.0),
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
