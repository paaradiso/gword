import gleam/list
import gleam/option
import lustre
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event
import words

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type Model {
  Model(selected_word: option.Option(String))
}

fn init(_) {
  Model(selected_word: option.None)
}

type Message {
  SelectWord(word: String)
}

fn update(_model: Model, message: Message) -> Model {
  case message {
    SelectWord(word) -> {
      case list.contains(words.word_bank, word) {
        True -> Model(selected_word: option.Some(word))
        False -> Model(selected_word: option.None)
      }
    }
  }
}

fn view(model: Model) {
  html.div(
    [],
    list.map(words.word_bank, fn(word) {
      html.p(
        [
          event.on_click(SelectWord(word)),
          attribute.class(case model.selected_word == option.Some(word) {
            True -> "font-bold"
            False -> ""
          }),
        ],
        [element.text(word)],
      )
    }),
  )
}
