/**
 * Generate a number of rooms, spread them out, and connect them with corridors.
 *
 * Will keep generating rooms until there is at least the configured minimum,
 * and until the maximum tries to see if a room fits has been reached.
 *
 * Small rooms are allowed to spawn inside larger rooms.
 */

module hackd.dungeon.RoomsGenerator;

import hackd.dungeon.model.ILevelGenerator;
import hackd.dungeon.Level;

/**
 * RoomsGenerator class
 */

class RoomsGenerator : ILevelGenerator
{
    /**
     * The generator configuration
     */

    struct Config
    {
        /**
         * The minimum room dimensions
         */

        size_t min_room_width;

        size_t min_room_height;

        /**
         * The minimum number of rooms
         */

        size_t min_rooms;

        /**
         * The maximum number of tries to see if a room fits
         */

        uint max_fit_tries;
    }

    private Config config;

    /**
     * Constructor
     */

    this ( )
    {
        enum MinRoomWidth = 5;
        enum MinRoomHeight = 5;
        enum MinRooms = 1;
        enum MaxFitTries = 5;

        this.config = Config(MinRoomWidth, MinRoomHeight, MinRooms, MaxFitTries);
    }

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

    override Level generate ( size_t width, size_t height )
    {
        import std.random;

        auto level = Level(width, height);

        /**
         * Check if a room will fit at the given coordinates
         */

        bool willFit ( size_t row, size_t col, Level room )
        {
            if ( row + room.height >= height || col + room.width >= width )
            {
                return false;
            }

            for ( auto i = row; i < row + room.height; i++ )
            {
                for ( auto j = col; j < col + room.width; j++ )
                {
                    if ( level[i][j] == Wall )
                    {
                        return false;
                    }
                }
            }

            return true;
        }

        uint rooms_placed;
        uint fit_tries;

        while ( rooms_placed < this.config.min_rooms && fit_tries < this.config.max_fit_tries )
        {
            auto room = generateRoom(width / this.config.min_rooms,height / this.config.min_rooms);

            auto row = 3;//uniform(0, height - room.height);
            auto col = 3;//uniform(0, width - room.width);

            if ( !willFit(row, col, room) )
            {
                fit_tries++;
                continue;
            }
            else
            {
                level.set(row, col, room);
                rooms_placed++;
            }
        }

        return level;
    }

    /**
     * Generate a random room within the given dimensions
     *
     * Params:
     *      max_width = The maximum width
     *      max_height = The maximum height
     */

    private Level generateRoom ( size_t max_width, size_t max_height )
    in
    {
        assert(max_width >= this.config.min_room_width);
        assert(max_height >= this.config.min_room_height);
    }
    body
    {
        import std.random;

        auto width = uniform(this.config.min_room_width, max_width + 1);
        auto height = uniform(this.config.min_room_height, max_height + 1);

        auto room = Level(width, height);

        foreach ( i, ref row; room )
        {
            foreach (j, ref col; row )
            {
                col = i == 0 || i == room.height - 1 || j == 0 || j == room.width - 1 ?
                    Wall : Floor;
            }
        }

        return room;
    }
}
