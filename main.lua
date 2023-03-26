local palavras = {"banana", "computador", "zebra", "elefante", "abacaxi", "ornitorrinco", "gerador", "morango", "cadeira", "unicornio", "rinoceronte"}

local jogo = {
  palavra = palavras[love.math.random(#palavras)],
  letras_usadas = {},
  chances_restantes = 6,
  jogoGanho = false,
  estaAtivo = true
}

for i = 1, #palavras do
  jogo.letras_usadas[i] = false
end

function draw_forca(chances_restantes)
  -- forca
  love.graphics.line(50, 50, 50, 350)
  love.graphics.line(50, 50, 200, 50)
  love.graphics.line(200, 50, 200, 75)

  if chances_restantes < 6 then
    love.graphics.circle("line", 200, 100, 25)
  end

  if chances_restantes < 5 then
    love.graphics.line(200, 125, 200, 225)
  end

  if chances_restantes < 4 then
    love.graphics.line(200, 150, 175, 175)
  end

  if chances_restantes < 3 then
    love.graphics.line(200, 150, 225, 175)
  end

  if chances_restantes < 2 then
    love.graphics.line(200, 225, 175, 250)
  end

  if chances_restantes < 1 then
    love.graphics.line(200, 225, 225, 250)
  end
end

function check_jogoGanho()
  for i = 1, #jogo.palavra do
    local letra = jogo.palavra:sub(i, i)
    if not jogo.letras_usadas[letra] then
      return false
    end
  end
  jogo.jogoGanho = true
  return true
end

function draw_palavra(palavra, letras_usadas)
  local x = 50
  local y = 400
  for i = 1, #palavra do
    local letra = palavra:sub(i, i)
    if letras_usadas[letra] then
      love.graphics.print(letra, x, y)
    else
      love.graphics.print("_", x, y)
    end
    x = x + 30
  end
end

function love.keypressed(key)
  if jogo.estaAtivo and not jogo.jogoGanho and key:match("[a-zA-Z]") then
    local letra = key:lower()

    if not jogo.letras_usadas[letra] then
      jogo.letras_usadas[letra] = true;

      if not jogo.palavra:match(letra) then
        jogo.chances_restantes = jogo.chances_restantes - 1

        if jogo.chances_restantes == 0 then
          jogo.estaAtivo = false
        end
      end
      
      check_jogoGanho()
    end
  end
end


function love.draw()
  draw_forca(jogo.chances_restantes)
  draw_palavra(jogo.palavra, jogo.letras_usadas)
  if not jogo.estaAtivo then
    love.graphics.print("Você foi enforcado :(", 10, 10)
  elseif jogo.jogoGanho then
    love.graphics.print("Você ganhou!", 10, 10)
  end
end