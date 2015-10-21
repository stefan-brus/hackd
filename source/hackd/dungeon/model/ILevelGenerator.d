/**
 * Level generator interface
 */

module hackd.dungeon.model.ILevelGenerator;

import hackd.dungeon.Level;

/**
 * The ILevelGenerator interface
 */

interface ILevelGenerator
{
    /**
     * Generate a random level of the given dimensions
     *
     * Params:
     *      width = The level width
     *      height = The level height
     *
     * Returns:
     *      The generated level
     */

    Level generate ( size_t width, size_t height );
}
