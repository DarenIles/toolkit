
require_relative 'lib/client'
module Kenna 
module Toolkit
class SecurityScorecard < Kenna::Toolkit::BaseTask

  def self.metadata 
    {
      id: "security_scorecard",
      name: "Security Scorecard",
      disabled: true, 
      description: "This task connects to the Security Scorecard API and pulls results into the Kenna Platform.",
      options: [
        { :name => "ssc_api_key", 
          :type => "string", 
          :required => true, 
          :default => "", 
          :description => "This is the Security Scorecard key used to query the API." },
        { :name => "kenna_api_key", 
          :type => "api_key", 
          :required => false, 
          :default => nil, 
          :description => "Kenna API Key" },
        { :name => "kenna_api_host", 
          :type => "hostname", 
          :required => false, 
          :default => "api.kennasecurity.com", 
          :description => "Kenna API Hostname" },
        { :name => "kenna_connector_id", 
          :type => "integer", 
          :required => false, 
          :default => nil, 
          :description => "If set, we'll try to upload to this connector"  },    
        { :name => "output_directory", 
          :type => "filename", 
          :required => false, 
          :default => "output/security_scorecard", 
          :description => "If set, will write a file upon completion. Path is relative to #{$basedir}"  }
      ]
    }
  end

  def run(options)
    super
  
    kenna_api_host = @options[:kenna_api_host]
    kenna_api_key = @options[:kenna_api_key]
    kenna_connector_id = @options[:kenna_connector_id]
    ssc_api_key = @options[:ssc_api_key]

    client = Kenna::Toolkit::Ssc::Client.new(ssc_api_key)

    ### Basic Sanity checking
    unless client.succesfully_authenticated?
      print_error "Unable to proceed, invalid key for Security Scorecard?"
      return
    else 
      print_good "Successfully authenticated!"
    end
  
    ### This does the work. Connects to API and shoves everything into memory as KDI
    @assets = []; @vuln_defs = [] # currently a necessary side-effect

    ### Write KDI format
    #kdi_output = { skip_autoclose: false, assets: @assets, vuln_defs: @vuln_defs }
    #output_dir = "#{$basedir}/#{@options[:output_directory]}"
    #filename = "security_scorecard.kdi.json"
    #write_file output_dir, filename, JSON.pretty_generate(kdi_output)
    #print_good "Output is available at: #{output_dir}/#{filename}"

    ### Finish by uploading if we're all configured
    #if kenna_connector_id && kenna_api_host && kenna_api_key
    #  print_good "Attempting to upload to Kenna API at #{kenna_api_host}"
    #  upload_file_to_kenna_connector kenna_connector_id, kenna_api_host, kenna_api_key, "#{output_dir}/#{filename}"
    #end

  end    
end
end
end