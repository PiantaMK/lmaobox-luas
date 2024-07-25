Island = {}

function Island:Island(label, x, w, starty, endy)
    draw.Color(201, 201, 201, 255)
    local fixedTextStartX = x + 10
    draw.Text(fixedTextStartX, starty, label)

    local _, label_tstarty = draw.GetTextSize(label)
    draw.Color(44, 44, 44, 255)
    draw.Line(x, starty + (label_tstarty//2), fixedTextStartX - 5, starty + (label_tstarty//2))
    draw.Line(fixedTextStartX + draw.GetTextSize(label) + 3, starty + (label_tstarty//2), x + w, starty + (label_tstarty//2))
    draw.Line(x, starty + (label_tstarty//2), x, endy)
    draw.Line(x + w, starty + (label_tstarty//2), x + w, endy)
    draw.Line(x, endy, x + w, endy)
end


return Island