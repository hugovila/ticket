require 'rubygems'
require 'sinatra'
require 'i18n'
# require 'i18n/backend/fallbacks'

set :bind, '0.0.0.0'

configure do
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.backend.load_translations
end

PROJECT_NAME = "Ticket Dispenser"
COMPANY      = "Devscola"
CREATOR      = "Hugo Vila"

I18n.load_path = Dir['./locales/*.yml', './locales/*.rb']
I18n.locale = :en
I18n.default_locale = :en

helpers do
  def t(*key)
    I18n.t(*key)
  end
end

# before '/:locale/*' do
#   I18n.locale       =       params[:locale]
#   request.path_info = '/' + params[:splat ][0]
# end


get '/' do

  data = {}

    params[:load_path] = I18n.load_path
    params[:HTTP_ACCEPT_LANGUAGE] = request.env['HTTP_ACCEPT_LANGUAGE']

    params[:I18n_locale] = I18n.locale
  data[:I18n_available_locales] = I18n.available_locales

	data[:browser_locale] = obtain_browser_locale #:en
	I18n.locale = obtain_browser_locale

	data[:company] = COMPANY
	data[:creator] = CREATOR

	erb :get_your_ticket, :layout => :layout_home, locals: { data: data }
end

# before '/:mi_var/*' do
#   I18n.locale       =       params[:mi_var]
#   request.path_info = '/' + params[:splat ][0]
# end

get '/ticket/data' do

  data = {}

	# data[:I18n_locale] = I18n.locale 

  I18n.locale = obtain_browser_locale

  data[:I18n_available_locales] = I18n.available_locales
  data[:browser_locale] = obtain_browser_locale
	
	data[:company] = COMPANY
	data[:creator] = CREATOR

	erb :ticket_data, locals: { data: data }
end

post '/ticket/template' do

  data = {}

	# params[:I18n_locale] = I18n.locale
  # params[:I18n_available_locales] = I18n.available_locales

	# params[:browser_locale] = obtain_browser_locale
	# I18n.locale = obtain_browser_locale

  I18n.locale = obtain_browser_locale

  data[:I18n_available_locales] = I18n.available_locales
  data[:browser_locale] = obtain_browser_locale
	
	data[:company] = COMPANY
  data[:creator] = CREATOR

	erb :ticket_template, locals: { data: data }
end

post '/ticket/print' do

  data = {}

  # params[:I18n_locale] = I18n.locale
  # params[:I18n_available_locales] = I18n.available_locales

  I18n.locale = obtain_browser_locale

  data[:I18n_available_locales] = I18n.available_locales
  data[:browser_locale] = obtain_browser_locale

	params[:browser_locale] = obtain_browser_locale
	I18n.locale = obtain_browser_locale

  data[:company] = COMPANY
  data[:creator] = CREATOR
	
	renderize(params[:template], locals: { data: data })

end

get '/ticket/print/:name/:surname/:where/:when/:template' do

  data = {}

  data[:I18n_available_locales] = I18n.available_locales
  data[:browser_locale] = obtain_browser_locale

  data[:company] = COMPANY
  data[:creator] = CREATOR
	
	renderize(params[:template], locals: { data: data })

end

def renderize(template, locals)

  templates = { :black_night => :template_ticket_black, :moon_night => :template_ticket_moon, :starry_night => :template_ticket_starry }

	params[:title] = "Ticket Dispenser"

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

not_found do
  status 404
  params[:content] = 'not found'
  erb :not_found_404, :layout => false
end


