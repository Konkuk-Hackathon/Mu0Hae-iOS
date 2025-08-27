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
    
    init(
        services: Services = .live,
        repositories: Repositories? = nil,
        useCases: UseCases? = nil
    ) {
        self.services = services
        self.repositories = repositories ?? Repositories(services: services)
        self.useCases = useCases ?? UseCases(repositories: self.repositories)
    }
}

extension DIContainer {
    struct Services {
        let chatNetwork: ChatNetworkService
        
        static var live: Self {
            .init(chatNetwork: ChatNetworkService())
        }
    }
    
    struct Repositories {
        let chat: ChatRepository
        
        init(services: Services) {
            self.chat = DefaultChatRepository(chatService: services.chatNetwork)
        }
    }
    
    struct UseCases {
        let chat: ChatUseCase
        
        init(repositories: Repositories) {
            self.chat = DefaultChatUseCase(chatRepository: repositories.chat)
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
