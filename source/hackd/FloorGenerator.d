/**
 * The hyperdynamic floor generator
 *
 * Uses the algorithm described here:
 * http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
 */

module hackd.FloorGenerator;

import hackd.Floor;


/**
 * FloorGenerator class
 */

class FloorGenerator
{
    /**
     * Some starter tiles to experiment with
     */

    enum Empty = Tile('.', true);

    enum Wall = Tile('#', false);

    /**
     * The generator configuration
     */

    struct Config
    {
        /**
         * The initial wall density
         */

        double init_wall_density;

        /**
         * The number of iterations to generate caves and paths
         */

        uint path_iterations;

        /**
         * The number of iterations to smoothen the map
         */

        uint smooth_iterations;
    }

    private Config config;

    /**
     * Constructor
     */

    this ( )
    {
        enum InitWallDensity = 0.25;
        enum PathIterations = 10;
        enum SmoothIterations = 5;

        this.config = Config(InitWallDensity, PathIterations, SmoothIterations);
    }

    /**
     * Generate a random floor of the given dimensions
     *
     * Params:
     *      width = The floor width
     *      height = The floor height
     */

    Floor generate ( size_t width, size_t height )
    {
        auto floor = Floor(width, height);

        void initMap ( )
        {
            import std.random;

            foreach ( ref row; floor )
            {
                foreach ( ref col; row )
                {
                    col = uniform01() < this.config.init_wall_density ? Wall : Empty;
                }
            }
        }

        uint wallsWithinSteps ( int x, int y, int n )
        {
            bool isWall ( int x, int y )
            {
                if ( y < 0 || x < 0 || y >= floor.height - 1 || x >= floor.width - 1 )
                {
                    return true;
                }
                else
                {
                    return floor[y][x] == Wall;
                }
            }

            uint result;

            for ( int i = x - n; i < x + n + 1; i++ )
            {
                for ( int j = y - n; j < y + n + 1; j++ )
                {
                    if ( !(i == x && j == y) && isWall(i, j) )
                    {
                        result++;
                    }
                }
            }

            return result;
        }

        void generatePaths ( )
        {
            for ( auto iter = 0; iter < this.config.path_iterations; iter++ )
            {
                foreach ( i, ref row; floor )
                {
                    foreach ( j, ref col; row )
                    {
                        col = wallsWithinSteps(j, i, 1) >= 5 || wallsWithinSteps(j, i, 4) <= 2 ? Wall : col;
                    }
                }
            }
        }

        void smoothenMap ( )
        {
            for ( auto iter = 0; iter < this.config.smooth_iterations; iter++ )
            {
                foreach ( i, ref row; floor )
                {
                    foreach ( j, ref col; row )
                    {
                        col = wallsWithinSteps(j, i, 1) >= 5 ? Wall : col;
                    }
                }
            }
        }

        initMap();
        generatePaths();
        smoothenMap();

        return floor;
    }
}
