require 'rubygems'
require 'sinatra'
require 'i18n'

configure do
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.backend.load_translations
end

PROJECT_NAME = "Ticket Dispenser"
COMPANY      = "Devscola"
AUTHOR      = "Hugo Vila"

I18n.load_path = Dir['./locales/*.yml', './locales/*.rb']
I18n.locale = :en
I18n.default_locale = :en

helpers do
  def t(*key)
    I18n.t(*key)
  end
end



get '/' do

  data = {}

  I18n.locale = obtain_browser_locale

  data[:I18n_available_locales] = I18n.available_locales
  data[:browser_locale] = obtain_browser_locale

  #data[:url_prefix_locale] = "/#{I18n.locale}"

	data[:company] = COMPANY
	data[:author] = AUTHOR

	erb :get_your_ticket, :layout => :layout_home, locals: { data: data }
end



get '/ticket/data' do

  data = {}

  I18n.locale = obtain_browser_locale

  data[:I18n_available_locales] = I18n.available_locales
  data[:browser_locale] = obtain_browser_locale

  #data[:url_prefix_locale] = "/#{I18n.locale}"
	
	data[:company] = COMPANY
	data[:author] = AUTHOR

	erb :ticket_data, :layout => :layout_data, locals: { data: data }
end



post '/ticket/template' do

  data = {}

  I18n.locale = obtain_browser_locale

  data[:I18n_available_locales] = I18n.available_locales
  data[:browser_locale] = obtain_browser_locale

  #data[:url_prefix_locale] = "/#{I18n.locale}"
	
	data[:company] = COMPANY
  data[:author] = AUTHOR

	erb :ticket_templates, :layout => :layout_templates, locals: { data: data }
end



post '/ticket/print' do

  data = {}

  I18n.locale = obtain_browser_locale

  data[:I18n_available_locales] = I18n.available_locales
  data[:browser_locale] = obtain_browser_locale

  #data[:url_prefix_locale] = "/#{I18n.locale}"

  data[:company] = COMPANY
  data[:author] = AUTHOR
	
	renderize(params[:template], locals: { data: data })

end



get '/ticket/print/:name/:surname/:where/:when/:template' do

  data = {}

  I18n.locale = obtain_browser_locale

  data[:I18n_available_locales] = I18n.available_locales
  data[:browser_locale] = obtain_browser_locale

  #data[:url_prefix_locale] = "/#{I18n.locale}"

  data[:company] = COMPANY
  data[:author] = AUTHOR
	
	renderize(params[:template], locals: { data: data })

end



not_found do
  data = {}
  status 404
  data[:your_are_in] = "not found"

  data[:company] = COMPANY
  data[:author] = AUTHOR

  erb :not_found_404, :layout => :layout_not_found_404, locals: { data: data }
end



# before '/' do
# redirect to("/#{obtain_browser_locale}/")
  
# end

# before '/:locale/*' do
#   I18n.locale       =       params[:locale]
#   request.path_info = '/' + params[:splat ][0]

# end




# get '/' do
#   data = {}

#   data[:locale] = I18n.locale
#   data[:locale] = params[:locale]

#   data[:prefix_locale] = '/' + params[:locale] + '/'

#   data[:company] = COMPANY
#   data[:author] = AUTHOR

#   erb :get_your_ticket, :layout => :layout_home_params_and_data, locals: { data: data }
# end


def renderize(template, locals)

  templates = { :black_night => :template_ticket_black, :moon_night => :template_ticket_moon, :starry_night => :template_ticket_starry }

	#params[:title] = "Ticket Dispenser"

	template = template.to_sym

	template_selected = :default_template

	template_selected = template if templates.has_key?(template)

	result = templates[template_selected]

	erb result, locals

end


def obtain_browser_locale
  browser_locale = request.env['HTTP_ACCEPT_LANGUAGE']
  result = []
  browser_locale = browser_locale.split(",").each { |item| result << item[0, 2].downcase }
  result << "en"
  result = result.uniq
  locale = result[0]
  return locale
end


def obtain_available_locales
  site_available_locales = I18n.available_locales
  result = []
  site_available_locales = site_available_locales.each { |item| result << item[1..2] }
  p result
end

