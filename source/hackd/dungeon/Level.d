/**
 * Level struct
 */

module hackd.dungeon.Level;

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
 * Some starter tiles to experiment with
 */

enum Empty = Tile(' ', false);

enum Wall = Tile('#', false);

enum Floor = Tile('.', true);

/**
 * Level struct
 */

struct Level
{
    /**
     * The dimensions of the level
     */

    size_t width;

    size_t height;

    /**
     * The level tiles
     */

    Tile[][] tiles;

    alias tiles this;

    /**
     * Constructor
     *
     * Params:
     *      width = The level width
     *      height = The level height
     */

    this ( size_t width, size_t height )
    {
        this.width = width;
        this.height = height;

        this = new Tile[][](height, width);

        foreach ( ref row; this )
        {
            foreach ( ref col; row )
            {
                col = Empty;
            }
        }
    }

    /**
     * Calculate the area of the level
     *
     * Returns:
     *      The area of the level
     */

    uint area ( )
    {
        return this.width * this.height;
    }

    unittest
    {
        auto level = Level.init;
        assert(level.area == 0);

        level = Level(10, 8);
        assert(level.area == 80);
    }

    /**
     * Set the tiles at the given start coordinates to the given level
     *
     * Params:
     *      row = The starting row
     *      col = The starting column
     *      level = The level to place
     */

    void set ( size_t row, size_t col, Level level )
    in
    {
        assert(row + level.height < this.height);
        assert(col + level.width < this.width);
    }
    body
    {
        for ( auto i = row; i < row + level.height; i++ )
        {
            for ( auto j = col; j < col + level.width; j++ )
            {
                this[i][j] = level[i - row][j - col];
            }
        }
    }

    unittest
    {
        /**
         * Helper function to create a pre-filled level
         */

        Level makeFilled ( Tile t, size_t width, size_t height )
        {
            auto result = Level(width, height);

            foreach ( ref row; result )
            {
                foreach ( ref col; row )
                {
                    col = t;
                }
            }

            return result;
        }

        auto base = makeFilled(Empty, 20, 20);
        assert(base[0][0] == Empty);
        assert(base[5][5] == Empty);

        auto walls1 = makeFilled(Wall, 5, 5);
        base.set(4, 4, walls1);
        assert(base[4][4] == Wall);
        assert(base[5][5] == Wall);
        assert(base[8][8] == Wall);

        auto walls2 = makeFilled(Wall, 6, 6);
        base.set(7, 7, walls2);
        assert(base[7][7] == Wall);
        assert(base[8][8] == Wall);
        assert(base[12][12] == Wall);
        assert(base[13][13] == Empty);
    }
}
