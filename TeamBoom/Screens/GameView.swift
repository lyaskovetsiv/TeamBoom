//
//  GameView.swift
//  TeamBoom
//
//  Created by Artem on 07.08.2023.
//

import SwiftUI

struct GameView: View {
	// MARK: - States & Properties

	@State private var isGame: Bool
	@State private var isOver: Bool
	@State private var question: String
	@State private var punishment: String
    @State private var isPaused: Bool
	private let gameModel: GameModel
	private var gameTime: Double

	// MARK: - Init

    init(isGame: Bool = false,
         isOver: Bool = false,
         question: String = "",
         punishment: String = "",
         isPaused: Bool = false,
         gameModel: GameModel,
         gameTime: Double = 10.0)

   {  self.isGame = isGame
      self.isOver = isOver
      self.question = question
      self.punishment = punishment
      self.isPaused = isPaused
      self.gameModel = gameModel
      self.gameTime = gameTime
    }

	// MARK: - UI

	var body: some View {
		ZStack {
			BackgroundGradientView()
			if isGame {
//				LottieBombView(name: "animation1", loopMode: .playOnce, animationSpeed: 7.76/gameTime)
                LottieView(name: "animation1", loopMode: .playOnce, animationSpeed: 7.76/gameTime, isPaused: isPaused)
                    .frame(width: 500, height: 500)
					.scaleEffect(1)
					.saturation(1.7)
					.animation(.easeIn, value: isGame)
			}
			VStack {
				Text(gameModel.question)
					.frame(width: 300)
					.font(.largeTitle)
					.padding(.horizontal, 10)
					.opacity(isGame ? 1 : 0)
					.offset(y: isGame ? 50 : -100)
					.animation(.easeIn(duration: 0.8), value: isGame)
				if isOver {
					Text(gameModel.endGame)
						.padding()
						.font(.largeTitle)
						.opacity(isGame ? 0 : 1)
						.offset(y: isGame ? 100 : -100)
				}
				Spacer()
				Button("Stop") {
                    isPaused.toggle()
					player.stop()
					player2.stop()
				}
				Button("Start Game") {
					playSound(key: "backgroundMusic", player: &player)
					playSound(key: "ticking", player: &player2)
					gameModel.askQuestion()
					isOver = false
					isGame.toggle()
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.95*gameTime) {
                        if isGame {
                            playSound(key: "explosion", player: &player)
                        }
					}
					DispatchQueue.main.asyncAfter(deadline: .now() + gameTime) {
						isOver.toggle()
						isGame.toggle()
						gameModel.gameOver()
					}
				}
				.modifier(ButtonViewModifier())
				.padding(.bottom, 30)
				.opacity(isGame ? 0 : 1)
				.offset(x: isGame ? 300 : 0)
				.animation(.default, value: isGame)
			}
		}
	}
}

// MARK: - Preview

struct GameView_Previews: PreviewProvider {

	static let gameModel = GameModel()
	static var previews: some View {
		GameView(gameModel: gameModel)
	}
}
