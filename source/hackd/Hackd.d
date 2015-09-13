/**
 * HackD game
 */

module hackd.Hackd;

import hackd.TileSet;

import adlib.ui.entity.TextEntity;
import adlib.ui.model.IGame;
import adlib.ui.GL;
import adlib.ui.SDL;

struct Tile
{
    char chr;
    bool passable;
}

enum Empty = Tile(' ', true),
     Wall  = Tile('#', false);

enum TileMap = [
    ' ': Empty,
    '#': Wall
];

enum SimpleRoom = [
    "########################",
    "#                      #",
    "#                      #",
    "#                      #",
    "#                      #",
    "#                      #",
    "#                      #",
    "#                      #",
    "#                      #",
    "#                      #",
    "#                      #",
    "#                      #",
    "#                      #",
    "#                      #",
    "#                      #",
    "########################"
];

struct Floor
{
    Tile[24][16] tiles;

    alias tiles this;

    this ( char[24][16] room_str )
    {
        foreach ( i, row; room_str )
        {
            foreach ( j, col; row )
            {
                assert(col in TileMap);
                this.tiles[i][j] = TileMap[col];
            }
        }
    }
}

struct Player
{
    uint x;
    uint y;

    Tile tile;
}

/**
 * Hackd game class
 */

class Hackd : IGame
{
    private Floor floor;

    private Player player;

    private TileSet tile_set;

    /**
     * Initialize the game
     */

    void init ( )
    {
        this.floor = Floor(SimpleRoom);
        this.player = Player(10, 10, Tile('P', false));

        this.tile_set = TileSet("# P");
    }

    /**
     * Render the world
     */

    void render ( )
    {
        GL.clear(GL.COLOR_BUFFER_BIT);

        auto tile_w = this.tile_set['#'].width,
             tile_h = this.tile_set['#'].height;

        foreach ( y, row; this.floor )
        {
            foreach ( x, col; row )
            {
                auto tile = this.tile_set[col.chr];
                tile.setPos(x * tile_w, y * tile_h / 2);
                tile.draw();
            }
        }

        auto player_tile = this.tile_set[this.player.tile.chr];
        player_tile.setPos(this.player.x * tile_w, this.player.y * tile_h / 2);
        player_tile.draw();

        GL.flush();
    }

    /**
     * Handle the given event
     *
     * Params:
     *      event = The event
     *
     * Returns:
     *      True if successful
     */

    bool handle ( SDL.Event event )
    {
        if ( event().type == SDL.Event.KEYDOWN ) switch ( event.getScancode() )
        {
            case SDL.Event.SCAN_UP:
                if ( this.player.y > 0 &&
                     this.floor[this.player.y - 1][this.player.x].passable )
                    this.player.y--;
                break;
            case SDL.Event.SCAN_LEFT:
                if ( this.player.x > 0 &&
                     this.floor[this.player.y][this.player.x - 1].passable )
                    this.player.x--;
                break;
            case SDL.Event.SCAN_DOWN:
                if ( this.player.y < 15 &&
                     this.floor[this.player.y + 1][this.player.x].passable )
                    this.player.y++;
                break;
            case SDL.Event.SCAN_RIGHT:
                if ( this.player.x < 23 &&
                     this.floor[this.player.y][this.player.x + 1].passable )
                    this.player.x++;
                break;
            default:
                break;
        }

        return true;
    }

    /**
     * Update the world
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last step
     */

     void step ( uint ms )
     {

     }
 }
