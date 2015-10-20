/**
 * The hyperdynamic cave generator
 *
 * Uses the algorithm described here:
 * http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
 */

module hackd.dungeon.CaveGenerator;

import hackd.dungeon.Floor;
import hackd.dungeon.model.IFloorGenerator;


/**
 * CaveGenerator class
 */

class CaveGenerator : IFloorGenerator
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

    override Floor generate ( size_t width, size_t height )
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

        uint wallsWithinSteps ( int row, int col, int n )
        {
            bool isWall ( int row, int col )
            {
                if ( row < 0 || col < 0 || row >= floor.height - 1 || col >= floor.width - 1 )
                {
                    return true;
                }
                else
                {
                    return floor[row][col] == Wall;
                }
            }

            uint result;

            for ( int i = row - n; i < row + n + 1; i++ )
            {
                for ( int j = col - n; j < col + n + 1; j++ )
                {
                    if ( !(i == row && j == col) && isWall(i, j) )
                    {
                        result++;
                    }
                }
            }

            return result;
        }

        void generatePaths ( )
        {
            auto new_floor = Floor(width, height);

            for ( auto iter = 0; iter < this.config.path_iterations; iter++ )
            {
                foreach ( i, ref row; new_floor )
                {
                    foreach ( j, ref col; row )
                    {
                        col = wallsWithinSteps(i, j, 1) >= 5 || wallsWithinSteps(i, j, 4) <= 2 ? Wall : floor[i][j];
                    }
                }
            }

            floor = new_floor;
        }

        void smoothenMap ( )
        {
            auto new_floor = Floor(width, height);

            for ( auto iter = 0; iter < this.config.smooth_iterations; iter++ )
            {
                foreach ( i, ref row; new_floor )
                {
                    foreach ( j, ref col; row )
                    {
                        col = wallsWithinSteps(j, i, 1) >= 5 ? Wall : floor[i][j];
                    }
                }
            }

            floor = new_floor;
        }

        initMap();
        generatePaths();
        smoothenMap();

        return floor;
    }
}
