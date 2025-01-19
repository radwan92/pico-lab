-- title:       Hello, world!
-- description: Simple program to print scrolling text.

Text = {
    x = 0,
    y = 60,
    color = 7,
    text = "hello, world!",
    len = print("hello, world!"),

    update = function(self)
        self.x = self.x + 1

        if self.x > 127 then
            self.x = 0
        end
    end,

    draw = function(self)
        print(self.text, self.x, self.y, self.color)

        if self.x + self.len > 127 then
            print(self.text, self.x - 128, self.y, self.color)
        end
    end
}

function _update60()
    Text:update()
end

function _draw()
    cls()

    Text:draw()
end
