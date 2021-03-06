--$Name: Highlighting and syntax example$
--$Version: 0x01$
--$Author: Николай Коновалов$
-- Не пытайтесь запускать этот файл как игру!

instead_version "2.0.3";
require 'format'              -- Предлагаю использовать одинарные кавычки для "технических строк"

style.constants = {
	username = "Ashford",
	nickname = 'jm-xa'
	id = 102,
	isCyborg = false,
	age = 0x19;
}

-- В комментариях отдельно выделяются метки TODO FIXME XXX

main = room {
	nam = "Название комнаты",
	dsc = [["Слова в кавычках"^]] .. " \"Слова в кавычках\"" ..
		[[[{link|Ссылки} на {xact|объекты} подсвечиваются особым образом: только идентификатор и скобки. Определение допускает использование {talk_to_me(hi)|аргументов} и нижнего подчеркивания. Более того: их можно {talk_to_me(]] .. visited(first_game_room) .. [[)|разрывать между строками}!]] ..
		"Ошибки в ссылках теперь легче отследить: {xactТекст}, {talk to me(txt)|Текст}",
	obj = {
		xact( 'xact', "Вы обратили внимание как разнятся строки, заключенные в одинарные и обычные кавычки?" ),
		xact( 'talk_to_me', function(s, txt) p(txt) end ),
		'obj1';
	},
};

first = obj{
	var {
		empty = {},						-- Подсветка фигурных скобок работает только в строках, можно не беспокоиться
		do = function(f)				-- Как насчет функций и прочих блоков?
			f()
			local b = {} 
			local c = { {} }
			if f {'is', 'okay', '?'} then
				b = {}
			end
			while false do
				b = {}
			end
			for i, v in ipairs {'some', 'values'} do
				print( i, v )
			end
			funcall( "str", {'one','two',3} )
		end
		seq1 = '\teou\n\t{',
		seq2 = "\toau\n\t{",			-- Подсветка спецсиволов в строках не работает
		seq3 = [[\taoe\n{]];
	},
	dsc = [[В случае, когда {ссылка} представлена одним словом - она подсвечивается целиком, что удобно когда просматриваешь dsc предметов. Можно использовать {"кавычки"}. {Не подсвечено} - хотя допустимая act-ссылка]],
	act = function(s)
		local onlyCharacters = '{xactid|text}'  -- подсветка ссылок не распространяется на строки в одинарных кавычках
		for field, _ in ipairs(s) do
			print(field)
		end

		if true then 					-- Правильно ли работает подсветка оператора выбора?
			aoeu()
		else
			aoeu()
		end
	end,
};

second_game_room = room{
	nam = "Вторая комната",
	dsc = [[Как хорошо видно \"\" экранированные кавычки подсвечиваются в строках такого формата. Это сделано умышлено, как намек об ошибке (так как экранирование не сработает и кавычки вот так и выведутся).]],
	obj = {
		xact('xact_is_italic', code[[walk 'nonExistingRoom'; p "Конструкция code отлично подсвечивает код"]]);
		xact('as_many_other_keywords', code [[ function() p "Количество пробелов между 'code' и '[[' - дело вкуса" end ]] )
	}, 
	stiring_match_ok = "\\" .. '"', "'"
};

-- TODO: 
-- Подсветка в забытых запятых/точек с запятой в таблицах
-- :colorsheme writter
