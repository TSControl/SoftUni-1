function startApp() {
    sessionStorage.clear();

    showHideMenuLinks();

    $(document).on({
        ajaxStart: function () {
            $('#loadingBox').show();
        },
        ajaxStop: function () {
            $('#loadingBox').hide();
        }
    });

    $('#infoBox', '#errorBox').on('click', function () {
        $(this).fadeOut();
    });

    function showInfo(message) {
        $('#infoBox').show();
        $('#infoBox > span').text(message);
        setTimeout(function () {
            $('#infoBox').fadeOut();
        }, 3000);
    }

    function showError(error) {
        $('#errorBox').show();
        $('#errorBox > span').text(error);
        $('#errorBox').on('click', function () {
            $(this).fadeOut();
        });
    }

    function handleAjaxError(response) {
        let errorMsg = JSON.stringify(response);

        if (response.readyState === 0)
            errorMsg = "Cannot connect die to network error.";

        if (response.resonseJSON && response.resonseJSON.description)
            errorMsg = response.resonseJSON.description;

        showError(errorMsg);
    }

    const kinveyBaseUrl = "https://baas.kinvey.com/";
    const kinveyAppKey = "kid_rkMtKform";
    const kinveyAppSecret = "53badeb768df46aaa0e0782d3c99a442";
    const kinvetAppAuthHeaders = {
        'Authorization': "Basic " + btoa(kinveyAppKey + ":" + kinveyAppSecret)
    };

    function saveAuthInSession(userInfo) {
        sessionStorage.setItem('authToken', userInfo._kmd.authtoken);
        sessionStorage.setItem('userId', userInfo._id);
        sessionStorage.setItem('userName', userInfo.username);
    }

    function getKinveyUserAuthHeaders() {
        return {
            'Authorization': "Kinvey " + sessionStorage.getItem('authToken')
        };
    }

    $('#registerButton').on('click', showRegisterView);
    $('#registerUser').on('click', registerUser);
    $('#loginButton').on('click', showLoginView);
    $('#logUserBtn').on('click', loginUser);
    $('#myListings').on('click', myListingView);
    $('#logout').on('click', logoutUser);
    $('#signUpBtn').on('click', showRegisterView);
    $('#signInBtn').on('click', showLogInView);
    $('#home').on('click', showHomeMenu);
    $('#allListings').on('click', allListings);
    $('#createListings').on('click', createListingsView);
    $('#createCars').submit(createCar);
    $('#editCars').submit(saveEditedCar);
    $("form").submit(function (event) {
        event.preventDefault();
    });

    function hideAllViews() {
        $('#main').hide();
        $('#login').hide();
        $('#registerForm').hide();
        $('#createCars').hide();
        $('#editCars').hide();
        $('#carMyListings').hide();
        $('#car-listings').hide();
        $('#listDetails').hide();
        $('#allListings').hide();
        $('#myListings').hide();
        $('#createListings').hide();
        $('#myListings').hide();
        $('#profile').hide();


    }

    function showHideMenuLinks() {
        hideAllViews();

        if (sessionStorage.getItem('authToken') === null) {
            $('#main').show();
        } else {
            $('#main').hide();
            $('#allListings').show();
            $('#myListings').show();
            $('#createListings').show();
            $('#profile').show();
            $('#car-listings').show();
            $('#welcm').text(`Welcome ${sessionStorage.getItem('userName')}`);
        }
    }

    function showHomeMenu() {
        showHideMenuLinks();
    }

    function createListingsView() {
        hideAllViews();
        $('#createCars').show();
    }

    function showRegisterView() {
        hideAllViews();
        $('#registerForm').show();
    }

    function showLoginView() {
        hideAllViews();
        $('#login').show();
    }

    function loginUser() {
        let username = $('#formLogin inpupt[name="username"]').val();
        let password = $('#formLogin inpupt[name="password"]').val();

        let usernameRegex = /[A-Za-z]{3,}/;
        let passRegex = /[A-Za-z0-9]{6,}/;

        if (!usernameRegex.test(username)) {
            showError("Username length should be...");
        } else if (!passRegex.test(password)) {
            showError("Password should be ...");
        } else {
            $.ajax({
                    method: "POST",
                    url: kinveyBaseUrl + "user/" + kinveyAppKey + "/login",
                    data: {
                        username,
                        password
                    },
                    headers: kinvetAppAuthHeaders
                }).then(function (res) {
                    saveAuthInSession(res);
                    showHideMenuLinks();
                    allListings();
                    showInfo("Login successful.");
                })
                .catch(handleAjaxError);
        }

    }

    function registerUser() {
        let username = $('#registerForm inpupt[name="username"]').val();
        let password = $('#registerForm inpupt[name="password"]').val();
        let repeatPass = $('#registerForm inpupt[name="repeatPass"]').val();


        let usernameRegex = /[A-Za-z]{3,}/;
        let passRegex = /[A-Za-z0-9]{6,}/;

        if (!usernameRegex.test(username)) {
            showError("Username length should be...");
        } else if (!passRegex.test(password)) {
            showError("Password should be ...");
        } else if (password !== repeatPass) {
            showError("Pass and repeat are not the same");
        } else {
            $.ajax({
                    method: "POST",
                    url: kinveyBaseUrl + "user/" + kinveyAppKey + "/",
                    data: {
                        username,
                        password
                    },
                    headers: kinvetAppAuthHeaders
                }).then(function (res) {
                    saveAuthInSession(res);
                    showHideMenuLinks();
                    allListings();
                    showInfo("Registration successful.");
                })
                .catch(handleAjaxError);
        }
    }

    function logoutUser() {
        $.ajax({
                method: "POST",
                url: kinveyBaseUrl + "user/" + kinveyAppKey + "/_logout",
                data: {
                    username,
                    password
                },
                headers: getKinveyUserAuthHeaders()
            })
            .then(function () {
                sessionStorage.clear();
                $('#welcm').text('');
                showHideMenuLinks();
                showInfo('Logout successful.');
            }).catch(handleAjaxError);


    }

    function allListings() {

    }
}