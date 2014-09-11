require 'net/ftp'
require 'date'
require 'optparse'

class FtpSearch
  def option_parser
    options = {}

    option_parser = OptionParser.new do |opts|
      # 这里是这个命令行工具的帮助信息
      opts.banner = 'here is help messages of the command line tool.'

      # Option 作为 flag，带argument，用于将argument作为数值解析，比如"name"信息
      # 下面的“value”就是用户使用时输入的argument

      opts.on("-h URL", '--host URL', 'ftp hostname') do |value|
        options[:host] = value
      end

      opts.on('-u NAME', '--username Name', 'ftp username') do |value|
        options[:username] = value
      end

      opts.on('-p PASSWORD', '--password PASSWORD', 'ftp password') do |value|
        options[:password] = value
      end

      opts.on('--path PATH', 'ftp path') do |value|
        options[:path] = value
      end

      opts.on('-m STR', '--match STR', 'filename you want to search') do |value|
        options[:match] = value
      end
    end.parse!

    @server = options[:host]
    @user = options[:username]
    @password = options[:password]
    @path = options[:path]
    @keywords = options[:match]
  end

  def do_search
    option_parser
    Net::FTP.open(@server, @user, @password) do |ftp|
      ftp.chdir(@path) unless @path.nil?
      if @keywords.nil? || @keywords.empty?
        p ftp.nlst
      else
        p ftp.nlst.select{|i| i.to_s.scan(@keywords).any?}
      end
    end
  end
end

FtpSearch.new.do_search