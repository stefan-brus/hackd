/**
 * Floor struct
 */

module hackd.Floor;

/**
 * Tile struct
 */

struct Tile
{
    /**
     * The character of this tile, this is also its key into the tileset
     */

    char chr;

    /**
     * Whether or not the player can cross this tile
     */

    bool passable;
}

/**
 * Floor struct
 */

struct Floor
{
    /**
     * The dimensions of the floor
     */

    size_t width;

    size_t height;

    /**
     * The floor tiles
     */

    Tile[][] tiles;

    alias tiles this;

    /**
     * Constructor
     *
     * Params:
     *      width = The floor width
     *      height = The floor height
     */

    this ( size_t width, size_t height )
    {
        this.width = width;
        this.height = height;

        this = new Tile[][](height, width);
    }
}
