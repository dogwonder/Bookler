# PrinceXML Ruby interface. 
# http://www.princexml.com
#
# Library by Subimage Interactive - http://www.subimage.com
#
#
# USAGE
# -----------------------------------------------------------------------------
#   princely = Princely.new()
#   html_string = render_to_string(:template => 'some_document')
#   send_data(
#     princely.pdf_from_string(html_string),
#     :filename => 'some_document.pdf'
#     :type => 'application/pdf'
#  )
#
module Princely
  autoload :PdfHelper, 'princely/pdf_helper'

  class Prince
    VERSION = "1.0.0" unless const_defined?("VERSION")
    
    attr_reader :exe_path, :style_sheets, :log_file, :logger

    # Initialize method
    #
    def initialize()
      # Finds where the application lives, so we can call it.
      @exe_path = `which prince`.chomp
      raise "Cannot find prince command-line app in $PATH" if @exe_path.length == 0
      @style_sheets = ''
    end
    
    # Sets stylesheets...
    # Can pass in multiple paths for css files.
    #
    def add_style_sheets(*sheets)
      for sheet in sheets do
        @style_sheets << " -s #{sheet} "
      end
    end
    
    # Returns fully formed executable path with any command line switches
    # we've set based on our variables.
    #
    def exe_path
      # Add any standard cmd line arguments we need to pass
      @exe_path << " --input=html --server "
      @exe_path << @style_sheets
      return @exe_path
    end
    
    # Makes a pdf from a passed in string.
    #
    # Returns PDF as a stream, so we can use send_data to shoot
    # it down the pipe using Rails.
    #
    def pdf_from_string(string, output_file = '-')
      path = self.exe_path()
      # Don't spew errors to the standard out...and set up to take IO 
      # as input and output
      path << ' --silent - -o -'
      
      # Show the command used...
      
      # Actually call the prince command, and pass the entire data stream back.
      pdf = IO.popen(path, "w+")
      pdf.puts(string)
      pdf.close_write
      result = pdf.gets(nil)
      pdf.close_read
      return result
    end

    def pdf_from_string_to_file(string, output_file)
      path = self.exe_path()
      # Don't spew errors to the standard out...and set up to take IO 
      # as input and output
      path << " --silent - -o '#{output_file}' "
      
      # Show the command used...
      
      # Actually call the prince command, and pass the entire data stream back.
      pdf = IO.popen(path, "w+")
      pdf.puts(string)
      pdf.close
      puts path
      return result
    end
  end
end