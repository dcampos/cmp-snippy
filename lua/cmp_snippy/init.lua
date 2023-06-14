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
    local documentation = {}
    if completion_item.data.snippet.description and completion_item.data.snippet.description ~= "" then
       	table.insert(documentation, completion_item.data.snippet.description)
       	table.insert(documentation, "----------")
    end
    local repr = require 'snippy'.get_repr(completion_item.data.snippet)
    local lines = vim.split(repr, '\n', true)
    table.insert(documentation, string.format('```%s', completion_item.data.filetype))
    for _, line in ipairs(lines) do
        table.insert(documentation, line)
    end
    table.insert(documentation, '```')

    completion_item.documentation = {
        kind = cmp.lsp.MarkupKind.Markdown,
        value = table.concat(documentation, '\n'),
    }

    callback(completion_item)
end

function source:execute(completion_item, callback)
    local snippet = completion_item.data.snippet
    local trigger = completion_item.word
    require 'snippy'.expand_snippet(snippet, trigger)
    callback(completion_item)
end

return source
