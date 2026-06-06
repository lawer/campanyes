local allowed = {
  section = true,
  header = true,
  footer = true,
}

function Div(el)
  local tag = el.attributes.tag
  if not tag then
    return nil
  end
  if not allowed[tag] then
    error("Etiqueta no permesa en tag=: " .. tag)
  end

  el.attributes.tag = nil
  local attrs = pandoc.write(pandoc.Pandoc({el}), "html")
  attrs = attrs:gsub("^<div", "<" .. tag, 1):gsub("</div>%s*$", "</" .. tag .. ">", 1)
  return pandoc.RawBlock("html", attrs)
end
