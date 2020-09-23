from flask import Flask, render_template


app = Flask(__name__)

@app.route('/')
@app.route('/index.html')
def root():
  # use render_template to convert the template code to HTML.
  # this function will look in the templates/ folder for your file.
  return render_template('mainpage.html', page_title='Main Page')

@app.route('/about')
def about():
  return render_template('about.html', page_title='About')

@app.route('/profile')
def profile():
  return render_template('profile.html', page_title='Profile')

@app.route('/settings')
def settings():
  return render_template('settings.html', page_title='Settings')

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080, debug=True)