
import webapp2
import jinja2
import os
import logging

from google.appengine.api import users
# Import ndb for appengine DataStore use
from google.appengine.ext import ndb


SUPPORTED_LOCALES = [
    'de-de',
    'en-au',
    'en-ca',
    'en-gb',
    'en-ie',
    'en-in',
    'en-nz',
    'en-us',
    'es-419',
    'es-es',
    'fr-fr',
    'it-it',
    'nl-nl',
    'pl-pl',
    'pt-br',
    'ru-ru',
    'sv-se',
    'tr-tr',
    'iw-il',
]      
# Setup jinja environment
JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader([
      os.path.dirname(__file__) + '/templates',
      os.path.dirname(__file__) + '/_modules'
      ]),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)

LOCALES_KEY = ndb.Key('Settings', "supported_locales")

# Setup ndb models
class Locale(ndb.Model):
  enabled = ndb.BooleanProperty(indexed=True)
  locale_id = ndb.StringProperty(indexed=True)

def get_enabled_locales():
      locale_query = Locale.query(ancestor=LOCALES_KEY)      
      enabled_locales_list = locale_query.filter(Locale.enabled==True).fetch()
      return enabled_locales_list

      
def get_supported_locales():
      return Locale.query(ancestor=LOCALES_KEY).order(Locale.locale_id).fetch()

# Route Handlers 
class MainHandler(webapp2.RequestHandler):
    def get(self):
      user = users.get_current_user()

      context = {
        'enabled_locales': get_enabled_locales()
      }

      if user:
        context['is_admin'] = users.is_current_user_admin()
        context['user'] = user
        context['nickname'] = user.nickname()
        context['logout_url'] = users.create_logout_url('/')
      else:
        context['login_url'] = users.create_login_url('/')

      template = JINJA_ENVIRONMENT.get_template('default.tpl')
      self.response.out.write(template.render(context))

class AdminHandler(webapp2.RequestHandler):
  def get(self):
      
    user = users.get_current_user()

    context = {
      'locales': get_supported_locales(),
    }

    if user:
      context['is_admin'] = users.is_current_user_admin()
      context['user'] = user
      context['nickname'] = user.nickname()
      context['logout_url'] = users.create_logout_url('/')
    else:
      context['login_url'] = users

    template = JINJA_ENVIRONMENT.get_template('admin.tpl')
    self.response.out.write(template.render(context))

class UpdateConfigHandler(webapp2.RequestHandler):
  def post(self):

    locale_store=Locale.query(ancestor=LOCALES_KEY);
    retrieved_locales = locale_store.fetch();

    logging.info('\n\nretrieved_Store FROM POST:%s\n\n', retrieved_locales)
    
    # [reset all entries enabled to flase]
    for locale in retrieved_locales:
          locale.enabled = False
          locale.put()

          
    # [Set Checked localed enabled to True]      
    selected_locales=self.request.get_all('locale-toggle')

    for locale in selected_locales:
          logging.info('\n\n\tEach Locale: %s',locale)
          locale_setting = Locale.query(ancestor=ndb.Key("Settings", "supported_locales")).filter(Locale.locale_id==locale).get()
          logging.info('\n\nGRABBED THE PROPER: %s', locale_setting)
          locale_setting.enabled=True
          locale_setting.put()

    self.redirect('/admin?')



class SeedHandler(webapp2.RequestHandler):
      def post(self):
            for locale in SUPPORTED_LOCALES:
                supported_locale = Locale(parent=ndb.Key("Settings", "supported_locales"))
                supported_locale.locale_id=locale
                supported_locale.enabled=False
                supported_locale.put()
            
            self.redirect('/admin')

_UNAUTHENTICATED_ROUTES = [
 webapp2.Route('/', MainHandler, name='home')
]

_ADMIN_ROUTES = [
 webapp2.Route('/admin/seed', SeedHandler, name='seed'),
 webapp2.Route('/admin/save-config', UpdateConfigHandler, name='admin'),
 webapp2.Route('/admin', AdminHandler, name='admin'),
]

app = webapp2.WSGIApplication(
     routes=(_UNAUTHENTICATED_ROUTES + _ADMIN_ROUTES), debug=True)
