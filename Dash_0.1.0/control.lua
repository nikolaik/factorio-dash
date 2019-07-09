-- Features:
--  - Send the following events to file `Dash-events.csv`:
--    - event: Log if attacked by other force and a player is not the target
--
-- References:
--  - serpent serialization library: https://github.com/pkulchenko/serpent
--  - the global `game`: https://lua-api.factorio.com/latest/LuaGameScript.html

-- TODO ideas:
--  - Take screenshot every 10 seconds and show on screen
--  - Alert if enemies are attacking (event) https://lua-api.factorio.com/latest/events.html#on_entity_damaged
--  - Alert if player died (event) https://lua-api.factorio.com/latest/events.html#on_player_died
--  - Alert on player joined/left (event) https://lua-api.factorio.com/latest/events.html#on_player_joined_game https://lua-api.factorio.com/latest/events.html#on_player_left_game
--  - Alert on research started/finished (event) https://lua-api.factorio.com/latest/events.html#on_research_finished https://lua-api.factorio.com/latest/events.html#on_research_started
--  - Show console chat https://lua-api.factorio.com/latest/events.html#on_console_chat
--  - Show some game stats (save to separate file): f.ex playtimez

script.on_init(function()
    -- run something on init
end)

function log_event(event_name, values)
    values = values or {}
    -- Show this on the big screen
    local events_file = 'Dash-events.csv'
    -- Append the event to a CSV file.
    local content = event_name .. ',' .. table.concat(values, ",") .. '\n'
    game.print('YOLO! Logging event: ' .. content)
    log('YOLO! Logging event: ' .. content)
    game.write_file(events_file, content, true) -- written to $GAME_DIR/script-output
end

script.on_event(defines.events.on_player_joined_game,
    function(event)
        local player_joined = game.players[event.player_index]
        log_event('player_joined_game', {player_joined.name})
    end
)

script.on_event(defines.events.on_entity_damaged,
    function(event)
        -- TODO: Log if not caused by player and player is not the target
        --log(serpent.dump(event.entity.name))
        local values = {event.entity.name}

        if event.entity.is_player() then
            table.insert(values, event.entity.character.name)
        end

        log(serpent.dump(event.cause))
        if event.cause then
            table.insert(values, event.cause.name)
        end

        log_event('entity_damaged', values)
    end
)
-- Unused example code:
--script.on_event(defines.events.on_tick,
    --function (event)
    --    tps = 60 -- ticks per second
    --    if event.tick % tps*3 == 0 then --common trick to reduce how often this runs, we don't want it running every tick, just every 30 ticks, so twice per second
            --log_event('tick', event.tick / tps)
--            game.print('yolo '..event.tick / tps)
--            --for index,player in pairs(game.connected_players) do  --loop through all online players on the server
--        end
--    end
--)