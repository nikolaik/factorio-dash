-- References:
--  - serpent serialization library: https://github.com/pkulchenko/serpent
--  - the global `game`: https://lua-api.factorio.com/latest/LuaGameScript.html

-- Ideas:
--  - TODO: nodejs server reads events, updates the dashboard and plays a sound if we are attacked
--  - Take screenshot every 10 seconds and show on screen
--  - Alert if enemies are attacking (event) https://lua-api.factorio.com/latest/events.html#on_entity_damaged
--  - Alert if player died (event) https://lua-api.factorio.com/latest/events.html#on_player_died
--  - Alert on player joined/left (event) https://lua-api.factorio.com/latest/events.html#on_player_joined_game https://lua-api.factorio.com/latest/events.html#on_player_left_game
--  - Alert on research started/finished (event) https://lua-api.factorio.com/latest/events.html#on_research_finished https://lua-api.factorio.com/latest/events.html#on_research_started
--  - Show console chat https://lua-api.factorio.com/latest/events.html#on_console_chat
--  - Show some game stats (save to separate file)

script.on_init(function()
    -- run something on init
end)

function log_event(event_name, value)
    -- Show this on the big screen
    events_file = 'Dash-events.csv'
    game.print('YOLO! Logging event: ' .. event_name)
    -- Append the event to a CSV file.
    game.write_file(events_file, event_name .. ',' .. value, true, 0) -- written to $GAME_DIR/script-output
end

script.on_event(defines.events.on_player_joined_game,
    function(player_index)
        --print(serpent.dump(player_index))
        player_joined = game.players[player_index.player_index]
        log_event('player_joined_game,', player_joined.name)
    end
)
-- Unused example code:
--script.on_event(defines.events.on_tick,
--    function (event)
--        tps = 60 -- ticks per second
--        if event.tick % tps*3 == 0 then --common trick to reduce how often this runs, we don't want it running every tick, just every 30 ticks, so twice per second
--            game.print('yolo '..event.tick / tps)
--            --for index,player in pairs(game.connected_players) do  --loop through all online players on the server
--            --
--            --    --if they're wearing our armor
--            --    if player.character and player.get_inventory(defines.inventory.character_armor).get_item_count("fire-armor") >= 1 then
--            --        --create the fire where they're standing
--            --        player.surface.create_entity{name="fire-flame", position=player.position, force="neutral"}
--            --    end
--            --end
--        end
--    end
--)