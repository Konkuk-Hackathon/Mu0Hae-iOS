//
//  DIContainer.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

struct DIContainer {
    let repositories: Repositories
    let useCases: UseCases
    let services: Services
    let viewModels: ViewModels?
    
    init(
        services: Services = .live,
        repositories: Repositories? = nil,
        useCases: UseCases? = nil
    ) {
        self.services = services
        self.repositories = repositories ?? Repositories(services: services)
        self.useCases = useCases ?? UseCases(repositories: self.repositories)
        self.viewModels = nil
    }
    
    @MainActor
    func createViewModels() -> ViewModels {
        return ViewModels(useCases: self.useCases)
    }
}

extension DIContainer {
    struct Services {
        let chatNetwork: ChatNetworkService
        let chatHistoryNetwork: ChatHistoryNetworkServiceProtocol
        let guest: GuestService
        
        static var live: Self {
            .init(
                chatNetwork: ChatNetworkService(),
                chatHistoryNetwork: ChatHistoryNetworkService(),
                guest: GuestService()
            )
        }
    }
    
    struct Repositories {
        let chat: ChatRepository
        let chatHistory: ChatHistoryRepository
        let guest: GuestRepository
        
        init(services: Services) {
            self.chat = DefaultChatRepository(chatService: services.chatNetwork)
            self.chatHistory = DefaultChatHistoryRepository(chatHistoryService: services.chatHistoryNetwork)
            self.guest = DefaultGuestRepository(guestService: services.guest)
        }
    }
    
    struct UseCases {
        let chat: ChatUseCase
        let chatHistory: ChatHistoryUseCase
        let guest: GuestUseCase
        
        init(repositories: Repositories) {
            self.chat = DefaultChatUseCase(chatRepository: repositories.chat)
            self.chatHistory = DefaultChatHistoryUseCase(repository: repositories.chatHistory)
            self.guest = DefaultGuestUseCase(repository: repositories.guest)
        }
    }
    
    @MainActor
    struct ViewModels {
        let chatViewModel: ChatViewModel
        let guestViewModel: GuestSelectionViewModel
        
        init(useCases: UseCases) {
            self.chatViewModel = ChatViewModel(chatUseCase: useCases.chat)
            self.guestViewModel = GuestSelectionViewModel(guestUseCase: useCases.guest)
        }
    }
}

// MARK: - Environment Integration
extension EnvironmentValues {
    @Entry var injected: DIContainer = DIContainer()
}

extension View {
    func inject(_ container: DIContainer) -> some View {
        return self
            .environment(\.injected, container)
    }
}
