require 'rubygems'
require 'sinatra'
require 'i18n'

set :bind, '0.0.0.0'

configure do
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.backend.load_translations
end

COMPANY      = "Devscola"
AUTHOR       = "Hugo Vila"

time = Time.new

I18n.load_path = Dir['./locales/*.yml', './locales/*.rb']
I18n.locale = :en
I18n.default_locale = :en
I18n.fallbacks.map(:es => :en)
I18n.fallbacks.map(:fr => :en)

helpers do
  def t(*key)
    I18n.t(*key)
  end
end


before '/' do
  redirect to("/#{obtain_browser_locale}/"), 307
end

before '/:locale/*' do
  I18n.locale       =       params[:locale]
  request.path_info = '/' + params[:splat ][0]
end


get '/' do

  data = {}

  # I18n.locale = obtain_browser_locale
  # data[:browser_locale] = obtain_browser_locale

  data[:url_prefix_locale] = "/#{I18n.locale}"



  data[:obtain_languages_locales_site_chain] = obtain_languages_locales_site_chain
  data[:year] = time.year

	erb :get_your_ticket, :layout => :layout_home, locals: { data: data }
end



get '/ticket/data' do

  data = {}

  # I18n.locale = obtain_browser_locale
  # data[:browser_locale] = obtain_browser_locale

  data[:url_prefix_locale] = "/#{I18n.locale}"



  data[:obtain_languages_locales_site_chain] = obtain_languages_locales_site_chain
  data[:year] = time.year

	erb :ticket_data, :layout => :layout_data, locals: { data: data }
end



before '/ticket/template' do
  # params[:when] = convert_data_form(params[:when])
end


post '/ticket/template' do

  data = {}

  # I18n.locale = obtain_browser_locale
  # data[:browser_locale] = obtain_browser_locale
  
  data[:url_prefix_locale] = "/#{I18n.locale}"



params[:when] = convert_data_form(params[:when])


  data[:obtain_languages_locales_site_chain] = obtain_languages_locales_site_chain
	data[:path_info] = request.path_info
  data[:year] = time.year

	erb :ticket_templates, :layout => :layout_templates, locals: { data: data }
end



post '/ticket/print' do

  data = {}

  #I18n.locale = obtain_browser_locale
  #data[:browser_locale] = obtain_browser_locale

  data[:url_prefix_locale] = "/#{I18n.locale}"

data[:when] = convert_data_form(params[:when])

  data[:obtain_languages_locales_site_chain] = obtain_languages_locales_site_chain
  data[:path_info] = request.path_info
  data[:year] = time.year
	
	renderize(params[:template], locals: { data: data })

end



get '/ticket/print/:name/:surname/:where/:when/:template' do

  data = {}

  #I18n.locale = obtain_browser_locale
  #data[:browser_locale] = obtain_browser_locale

  data[:url_prefix_locale] = "/#{I18n.locale}"

  
  data[:obtain_languages_locales_site_chain] = obtain_languages_locales_site_chain
  data[:path_info] = request.path_info
  data[:year] = time.year
	
	renderize(params[:template], locals: { data: data })

end


get '/ticket/print/:name/:surname/:where/:when_day/:when_month/:when_year/:template' do

  data = {}

  #I18n.locale = obtain_browser_locale
  #data[:browser_locale] = obtain_browser_locale

  data[:url_prefix_locale] = "/#{I18n.locale}"


  data[:obtain_languages_locales_site_chain] = obtain_languages_locales_site_chain
  data[:path_info] = request.path_info
  data[:company] = COMPANY
  data[:author] = AUTHOR
  data[:year] = time.year
  
  renderize(params[:template], locals: { data: data })

end



not_found do
  data = {}
  status 404
  data[:your_are_in] = "not found"

  data[:obtain_languages_locales_site_chain] = obtain_languages_locales_site_chain
  data[:year] = time.year

  erb :not_found_404, :layout => :layout_not_found_404, locals: { data: data }
end





def renderize(template, locals)

  templates = { :black_night => :template_ticket_black, :moon_night => :template_ticket_moon, :starry_night => :template_ticket_starry }

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


def obtain_languages_locales_site
  site_available_locales = I18n.available_locales
  result = Array.new
  site_available_locales.each { |item| result << item[0..2] }
  result
end

def obtain_language_locale_site(language)
  hash_of_languages = Hash.new
  I18n.available_locales.each { |item| hash_of_languages[item] = item.to_s  }
  hash_of_languages[language]
end

def obtain_languages_locales_site_chain

  the_result_i_whould_obtain = "<a href=\"/fr/\"><%= data[:obtain_language_locale_site_fr] %></a> | <a href=\"/en/\"><%= data[:obtain_language_locale_site_en] %></a> | <a href=\"/es/\"><%= data[:obtain_language_locale_site_es] %></a>"

  hash_of_languages = Hash.new
  languages_locales_site_chain = Array.new
  I18n.available_locales.sort.each do |item|
    languages_locales_site_chain << "<a href=\"/#{item.to_s}#{request.path_info}\">#{item.to_s.upcase}</a>"
  end
  languages_locales_site_chain.join(" | ")
end

def convert_data_form(data_to_convert)
  # data_converted = data_to_convert.gsub("\/", "&sol;")
  data_converted = data_to_convert.gsub("\/", "-")
end