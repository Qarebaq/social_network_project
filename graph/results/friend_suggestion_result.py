class FriendSuggestionResult:

    def __init__(self, suggested_user_id, mutual_friends, score):
        self.suggested_user_id = suggested_user_id
        self.mutual_friends = mutual_friends
        self.score = score

    def get_suggested_user_id(self):
        # TODO: return suggested user id
        pass

    def get_mutual_friends(self):
        # TODO: return mutual friends list
        pass

    def get_mutual_friends_count(self):
        # TODO: return number of mutual friends
        pass

    def get_score(self):
        # TODO: return suggestion score
        pass