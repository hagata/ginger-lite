
import webapp2
import jinja2
import os

# Setup jinja environment
JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader([
      os.path.dirname(__file__) + '/templates',
      os.path.dirname(__file__) + '/_modules'
      ]),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)


class MainHandler(webapp2.RequestHandler):
    def get(self):

        template_variables = {
        }

        template = JINJA_ENVIRONMENT.get_template('default.tmpl')
        self.response.out.write(template.render(template_variables))


app = webapp2.WSGIApplication([
    ('/', MainHandler)
], debug=True)
