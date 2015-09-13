/**
 * Tile set struct
 */

module hackd.TileSet;

import adlib.ui.entity.TextEntity;
import adlib.ui.SDL;

/**
 * TileSet struct
 */

struct TileSet
{
    /**
     * The associative array of tile character to entity
     */

    private TextEntity[char] tile_set;

    alias tile_set this;

    /**
     * Constructor
     *
     * Params:
     *      tiles = The string of tiles to initialize from
     */

    this ( string tiles )
    {
        foreach ( tile; tiles )
        {
            enum ColorWhite = SDL.Color(0xFF, 0xFF, 0xFF, 0xFF);

            this.tile_set[tile] = new TextEntity([tile], ColorWhite, 0, 0);
        }
    }

    /**
     * Index operator
     *
     * Params:
     *      chr = The tile character
     *
     * Returns:
     *      The text entity associated with the tile character
     */

    TextEntity opIndex ( char chr )
    in
    {
        assert(chr in this.tile_set);
    }
    body
    {
        return this.tile_set[chr];
    }
}
