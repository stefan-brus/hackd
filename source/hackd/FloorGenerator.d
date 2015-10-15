/**
 * The hyperdynamic floor generator
 */

module hackd.FloorGenerator;

import hackd.Floor;


/**
 * FloorGenerator class
 */

class FloorGenerator
{
    /**
     * Wall density in %
     */

    enum WalLDensity = 0.2;

    /**
     * Some starter tiles to experiment with
     */

    enum Empty = Tile('.', true);

    enum Wall = Tile('#', false);

    /**
     * Generate a random floor of the given dimensions
     *
     * Params:
     *      width = The floor width
     *      height = The floor height
     */

    Floor generate ( size_t width, size_t height )
    {
        import std.random;

        Floor floor = Floor(width, height);

        foreach ( ref row; floor )
        {
            foreach ( ref col; row )
            {
                col = uniform01() < WalLDensity ? Wall : Empty;
            }
        }

        return floor;
    }
}
