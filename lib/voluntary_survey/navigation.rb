module VoluntarySurvey
  module Navigation
    def self.voluntary_menu_customization
      voluntary_menu_options.each do |resource, options|
        options.each do |option, value|
          ::Voluntary::Navigation::Base.add_menu_option(resource, option, value)
        end
      end
    end
    
    def self.voluntary_menu_options
      {
        projects: {
          stories_after_resource_has_many: Proc.new do |story, options|
            story.item :results, I18n.t('survey_results.index.title'), story_results_path(@story)  
          end
        }
      }
    end
  end
end
    