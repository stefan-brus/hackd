/**
 * Floor generator interface
 */

module hackd.dungeon.model.IFloorGenerator;

import hackd.dungeon.Floor;

/**
 * The IFloorGenerator interface
 */

interface IFloorGenerator
{
    /**
     * Generate a random floor of the given dimensions
     *
     * Params:
     *      width = The floor width
     *      height = The floor height
     *
     * Returns:
     *      The generated floor
     */

    Floor generate ( size_t width, size_t height );
}
