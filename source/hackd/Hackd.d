/**
 * HackD game
 */

module hackd.Hackd;

import hackd.Floor;
import hackd.FloorGenerator;
import hackd.TileSet;

import adlib.ui.entity.TextEntity;
import adlib.ui.model.IGame;
import adlib.ui.GL;
import adlib.ui.SDL;

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
    /**
     * The floor generator
     */

    private FloorGenerator floor_gen;

    /**
     * The current floor
     */

    private Floor floor;

    /**
     * The player
     */

    private Player player;

    /**
     * The tileset
     */

    private TileSet tile_set;

    /**
     * Initialize the game
     */

    void init ( )
    {
        this.floor_gen = new FloorGenerator();
        this.floor = floor_gen.generate(50, 20);
        this.player = Player(10, 10, Tile('P', false));

        this.tile_set = TileSet("#.P");
    }

    /**
     * Render the world
     */

    void render ( )
    {
        GL.clear(GL.COLOR_BUFFER_BIT);

        auto tile_w = this.tile_set['#'].width,
             tile_h = this.tile_set['#'].height / 2;

        foreach ( y, row; this.floor )
        {
            foreach ( x, col; row )
            {
                auto tile = this.tile_set[col.chr];
                tile.setPos(x * tile_w + 400 - this.player.x * tile_w,
                            y * tile_h + 300 - this.player.y * tile_h);
                tile.draw();
            }
        }

        auto player_tile = this.tile_set[this.player.tile.chr];
        player_tile.setPos(400, 300);
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
                if ( this.player.y < this.floor.height - 1 &&
                     this.floor[this.player.y + 1][this.player.x].passable )
                    this.player.y++;
                break;
            case SDL.Event.SCAN_RIGHT:
                if ( this.player.x < this.floor.width - 1 &&
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
