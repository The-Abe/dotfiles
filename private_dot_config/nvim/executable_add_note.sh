#!/bin/bash

# Rofi configuratie voor een compact invoerveld
TYPE=$(echo -e "Log\nTodo\nIdea" | rofi -dmenu -i \
    -p "Type" \
    -lines 3 \
    -theme-str 'window {location: center; width: 300px;} listview {columns: 1;} entry { placeholder: "";}')

[ -z "$TYPE" ] && exit 0

case "${TYPE,,}" in
	l*) TYPE="Log" ;;
	t*) TYPE="Todo" ;;
	i*) TYPE="Idea" ;;
	*) exit 0 ;;
esac

ACTION=$(rofi -dmenu \
    -p "$TYPE" \
    -lines 0 \
    -theme-str 'window {location: center; width: 500px;} listview {enabled: false;} entry { placeholder: "";}')

if [ $? -eq 0 ]; then
	fn="add_log"; [ "$TYPE" = "Todo" ] && fn="add_todo"; [ "$TYPE" = "Idea" ] && fn="add_idea"
	nvim --headless -c "lua notes.${fn}('${ACTION}')" +qa
fi
