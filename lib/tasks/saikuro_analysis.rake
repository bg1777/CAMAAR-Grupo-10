# lib/tasks/saikuro_analysis.rake (VERSÃO CORRIGIDA)

namespace :saikuro do
  desc "Analyze cyclomatic complexity of Ruby files"
  task :analyze do
    class CyclomaticComplexityAnalyzer
      attr_reader :results

      def initialize
        @results = {}
      end

      def analyze_file(file_path)
        content = File.read(file_path)
        lines = content.split("\n")
        
        current_method = nil
        current_complexity = 1
        in_method = false

        lines.each_with_index do |line, idx|
          # Detectar apenas métodos explícitos (def no início da linha)
          if line.match?(/^\s*def\s+/)
            if current_method
              @results[current_method] = current_complexity
            end
            current_method = extract_method_name(line, file_path, idx + 1)
            current_complexity = 1
            in_method = true
          end

          # Contar decisões
          if in_method
            current_complexity += 1 if line.match?(/\bif\b|\bunless\b/)
            current_complexity += 1 if line.match?(/\belsif\b|\belse\b/)
            current_complexity += 1 if line.match?(/\bcase\b|\bwhen\b/)
            current_complexity += 1 if line.match?(/\bwhile\b|\buntil\b/)
            current_complexity += 1 if line.match?(/\bfor\b|\beach\b/)
            current_complexity += 1 if line.match?(/\?.*:/) # ternary
            current_complexity += 1 if line.match?(/\b&&\b|\band\b/) && !line.match?(/^\s*#/)
            current_complexity += 1 if line.match?(/\b\|\|\b|\bor\b/) && !line.match?(/^\s*#/)
            current_complexity += 1 if line.match?(/\brescue\b/)
          end

          # Detectar fim de método
          if in_method && line.match?(/^\s*end\s*$/)
            @results[current_method] = current_complexity
            current_method = nil
            current_complexity = 1
            in_method = false
          end
        end
      end

      def extract_method_name(line, file, line_num)
        method_name = line.match(/def\s+(\w+)/)[1]
        "#{file}:#{line_num}:#{method_name}"
      end

      def print_report(threshold = 3)
        puts "\n" + "=" * 80
        puts "CYCLOMATIC COMPLEXITY ANALYSIS (SAIKURO)"
        puts "=" * 80 + "\n"

        sorted = @results.sort_by { |_, cc| -cc }
        
        high_complexity = sorted.select { |_, cc| cc > threshold }

        if high_complexity.empty?
          puts "✓ No methods with complexity > #{threshold}"
        else
          puts "⚠ Methods with complexity > #{threshold}:\n\n"
          high_complexity.each do |method, cc|
            status = case cc
                     when 1..3 then "✓"
                     when 4..6 then "⚠"
                     else "✗"
                     end
            puts "  #{status} #{method}"
            puts "     Cyclomatic Complexity: #{cc}\n\n"
          end
        end

        puts "\n" + "=" * 80
        puts "SUMMARY"
        puts "=" * 80
        puts "Total methods analyzed: #{@results.size}"
        puts "Average complexity: #{(@results.values.sum.to_f / @results.size).round(2)}"
        puts "Max complexity: #{@results.values.max}"
        puts "Methods with CC > 3: #{high_complexity.size}"
        puts "=" * 80 + "\n"
      end
    end

    # Analisar arquivos
    paths = ENV['PATHS'] || 'app/models,app/controllers'
    threshold = ENV['THRESHOLD'] || 3

    analyzer = CyclomaticComplexityAnalyzer.new

    paths.split(',').each do |path|
      Dir.glob("#{path}/**/*.rb").each do |file|
        analyzer.analyze_file(file)
      end
    end

    analyzer.print_report(threshold.to_i)
  end
end
