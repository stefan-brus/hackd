/**
 * Main module
 */

module main;

import hackd.Hackd;

import adlib.ui.SDLApp;

int main ( )
{
    auto game = new Hackd();
    auto app = new SDLApp!true("Hackd", 800, 600, game);

    return app.run();
}
