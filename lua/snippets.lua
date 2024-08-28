local luasnip = require("luasnip")
local snippet = luasnip.parser.parse_snipmate

return function()
  luasnip.add_snippets('lua', {
    snippet(
      'ef',
      [[
        function()
          return Tablex.extend(
            $0
          )
        end
      ]]
    ),
    snippet(
      "sc",
      [[
        {
          name = "$1",
          enabled = true,
          start_predicate = function(self, rails, dt)
            return $2
          end,

          run = function(self, rails)
            self.enabled = false
            $0
          end,
        },
      ]]
    ),
    snippet(
      "fn",
      [[
        function($1) return $2 end$0
      ]]
    ),
    snippet(
      "fnt",
      [[
        function($1)
          $2
        end$0
      ]]
    ),
    snippet(
      "de",
      [[
        describe("$1", function()
          $2
        end)$0
      ]]
    ),
    snippet(
      "it",
      [[
        it("$1", function()
          $2
        end)$0
      ]]
    ),
    snippet(
      "do",
      [[
        do
          $1
        end$0
      ]]
    ),
    snippet(
      "ac",
      [[
        $1 = {
          codename = "$1",
          get_availability = function(self, entity)
            return $2
          end,
          _run = function(self, entity)
            $3
          end,
        }$0
      ]]
    ),
    snippet(
      "{",
      [[
        {
          $1
        }$0
      ]]
    ),
  })
end
