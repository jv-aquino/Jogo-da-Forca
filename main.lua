local palavras = {"banana", "computador", "zebra", "elefante", "abacaxi", "ornitorrinco", "gerador", "morango", "cadeira", "unicornio", "rinoceronte"}

local jogo = {
  palavra = palavras[love.math.random(#palavras)],
  letras_usadas = {},
  chances_restantes = 6,
  jogoGanho = false,
  estaAtivo = false,
  firstTime = true
}

function resetGame()
  jogo.palavra = palavras[love.math.random(#palavras)]
  jogo.letras_usadas = {}
  for i = 1, #jogo.palavra do
    jogo.letras_usadas[jogo.palavra:sub(i, i)] = false
  end
  jogo.chances_restantes = 6
  jogo.jogoGanho = false
  jogo.estaAtivo = true
  jogo.firstTime = false
end

for i = 1, #palavras do
  jogo.letras_usadas[i] = false
end

function love.load()
  local logo = love.image.newImageData("logo.png")
  love.window.setIcon(logo)

  love.window.setTitle("Jogo da Forca")

  font = love.graphics.newFont(24)
  
  bgMusic = love.audio.newSource("bgmusic.mp3", "stream")
  bgMusic:setVolume(0.3)
  bgMusic:setLooping(true)
  bgMusic:play()
end

function menu()
  love.graphics.setFont(font)
  love.graphics.print("Bem-vindo ao Jogo da Forca!", 130, 150)
  love.graphics.print("Pressione 'C' para começar ou 'S' para sair", 130, 200)
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
  if (not jogo.estaAtivo or jogo.jogoGanho) and (key == "s" or key == "S") then
    love.event.quit()
  elseif (not jogo.estaAtivo or jogo.jogoGanho) and (key == "c" or key == "C") then
    resetGame()
  elseif jogo.estaAtivo and not jogo.jogoGanho and key:match("[a-zA-Z]") then
    local letra = key:lower()

    if not jogo.letras_usadas[letra] then
      jogo.letras_usadas[letra] = true;

      if not jogo.palavra:match(letra) then
        jogo.chances_restantes = jogo.chances_restantes - 1
      end
      check_jogoGanho()
    end
  end
end

function love.draw()
  if jogo.estaAtivo and not jogo.jogoGanho then
    draw_forca(jogo.chances_restantes)
    draw_palavra(jogo.palavra, jogo.letras_usadas)
    if jogo.chances_restantes == 0 then
      jogo.estaAtivo = false
    elseif jogo.jogoGanho then
      jogo.jogoGanho = false
    end
  else
    if jogo.firstTime then
      menu()
    elseif jogo.chances_restantes == 0 then
      love.graphics.print("Você foi enforcado :(", 50, 200)
      love.graphics.print("A palavra era \"".. jogo.palavra.."\"", 50, 250)
      love.graphics.print("Pressione \"C\" para começar novamente ou \"S\" para sair", 50, 300)
    elseif jogo.jogoGanho then
      love.graphics.print("Você ganhou!!!", 150, 225)
      love.graphics.print("Pressione \"C\" para começar novamente ou \"S\" para sair", 50, 275)
    end
  end
end