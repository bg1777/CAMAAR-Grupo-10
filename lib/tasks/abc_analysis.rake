# lib/tasks/abc_analysis.rake

namespace :rubycritic do
  desc "Analyze ABC score and find methods >= 15"
  task :abc_check do
    puts "\n" + "=" * 80
    puts "ABC SCORE ANALYSIS (Methods >= 15)"
    puts "=" * 80 + "\n"
    
    require 'pathname'
    
    files = Dir.glob('app/**/*.rb')
    high_abc = []
    
    files.each do |file|
      content = File.read(file)
      lines = content.split("\n")
      
      current_method = nil
      method_content = []
      
      lines.each_with_index do |line, idx|
        if line.match?(/^\s*def\s+\w+/)
          current_method = line.match(/def\s+(\w+)/)[1]
          method_content = [line]
        elsif current_method && line.match?(/^\s*end\s*$/)
          method_content << line
          
          # Calcular ABC score
          abc = calculate_abc(method_content.join("\n"))
          
          if abc >= 15
            high_abc << {
              file: file,
              method: current_method,
              abc: abc,
              line: idx - method_content.size + 2
            }
          end
          
          current_method = nil
          method_content = []
        elsif current_method
          method_content << line
        end
      end
    end
    
    if high_abc.empty?
      puts "✅ Nenhum método com ABC score >= 15\n\n"
    else
      puts "⚠️  #{high_abc.size} método(s) com ABC score >= 15:\n\n"
      high_abc.each do |item|
        puts "  📍 #{item[:file]}:#{item[:line]}"
        puts "     Method: #{item[:method]}"
        puts "     ABC Score: #{item[:abc]}\n\n"
      end
    end
    
    puts "=" * 80 + "\n"
  end
  
  def calculate_abc(code)
    assignments = code.scan(/[a-z_]\w*\s*=/).size
    branches = code.scan(/\b(if|unless|elsif|when|case|rescue)\b/).size
    conditions = code.scan(/\b(&&|\|\||and|or)\b/).size
    
    Math.sqrt(assignments**2 + branches**2 + conditions**2).round(2)
  end
end
