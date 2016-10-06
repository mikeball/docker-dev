(ns hello1.core)

(defn foo
  "I don't do a whole lot."
  [x]
  (println x "Hello, World!"))



(defn say-hi [name]
  (str "hi " name))

(say-hi "bob")
