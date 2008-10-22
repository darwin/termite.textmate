class FileForTextMate < TermiteAPI::Worker
  def eat(original, current)
    res = ""
    l = 0
    while current do
      md = current.match(/((\/|~)[^\/ "'\]\)]*){2,}(:\d)?/)
      if md
        o = md.offset(0)
        res += current[l..o[0]-1] || ""
        file = current[o[0]..o[1]-1]
        efile = File.expand_path(file)
        line = md.captures[1] || 1
        style = ""
        style = "style='color:#080'" if File.directory?(efile)
        style = "style='color:#999'" unless File.exists?(efile)
        res += "<a #{style} href=\"txmt://open?url=efile://#{file}&line=#{line}&column=2\">#{file}</a>"
        current = md.post_match
        next
      end
      res += current || ""
      return res
    end
    nil
  end
end

$mound.workers << FileForTextMate.new