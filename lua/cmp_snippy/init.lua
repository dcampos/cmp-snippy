local cmp = require('cmp')

local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

function source:get_debug_name()
  return 'snippy'
end

source.get_keyword_pattern = function()
  return '\\%([^[:alnum:][:blank:]]\\|\\w\\+\\)'
end

function source:complete(request, callback)
    local items = require 'snippy'.get_completion_items()
    local results = {}

    for _, item in ipairs(items) do
        local data = item.user_data.snippy
        local cmp_item = {
            word = item.word;
            label = item.abbr;
            insertTextFormat = cmp.lsp.InsertTextFormat.Snippet;
            insertText = table.concat(data.snippet.body, '\n');
            kind = cmp.lsp.CompletionItemKind.Snippet;
            data = {
                filetype = request.context.filetype,
                snippet = data.snippet,
            };
        }
        table.insert(results, cmp_item)
    end

    callback(results)
end

function source:resolve(completion_item, callback)
    callback(completion_item)
end

-- function source:execute(completion_item, callback)
--     local snippet = completion_item.data.snippet
--     local trigger = completion_item.word
--     require 'snippy'.expand_snippet(snippet, trigger)
--     callback(completion_item)
-- end

return source
