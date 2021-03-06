require 'json'
require 'deep_merge'
require 'open-uri'

module Jekyll_Get_Data
  class Generator < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)

      config = site.config['jekyll_get_data']
      if !config
        warn "No config".yellow
        return
      end
      if !config.kind_of?(Array)
        config = [config]
      end

      config.each do |d|
        begin
          target = site.data[d['data']]
          source = JSON.load(open(d['json']))

          if target
            target.deep_merge(source)
          else
            site.data[d['data']] = source
          end
        rescue
          next
        end
      end
    end
  end
end
